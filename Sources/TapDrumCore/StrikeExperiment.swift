import Foundation

public enum DrumContact: String, CaseIterable, Hashable, Sendable {
    case thumb, index, middle, ring, little, palm
    public var label: String { self == .palm ? "Palm proxy" : rawValue.capitalized }
    var tip: HandJoint? {
        switch self {
        case .thumb: return .thumbTip
        case .index: return .indexTip
        case .middle: return .middleTip
        case .ring: return .ringTip
        case .little: return .littleTip
        case .palm: return nil
        }
    }
}

public struct ContactKey: Hashable, Sendable {
    public let hand: Handedness
    public let contact: DrumContact
    public init(hand: Handedness, contact: DrumContact) { self.hand = hand; self.contact = contact }
    public var label: String { "\(hand.rawValue.capitalized) \(contact.label)" }
}

public struct EstimatedStrike: Identifiable, Sendable {
    public let id: Int
    public let key: ContactKey
    public let evidence: StrikeEvidence
    public let recognizedHostTime: Double
    public let calibrationVersion: Int
    /// Minimum input-joint confidence. This is not a contact probability.
    public let landmarkConfidence: Double
}

public struct StrikeReadout: Sendable {
    public var message = "Set the playing area, then learn rest and lifted references."
    public var areaAvailable = false
    public var collecting = false
    public var enabled = false
    public var restKeys: Set<ContactKey> = []
    public var readyKeys: Set<ContactKey> = []
    public var states: [ContactKey: String] = [:]
    public var levels: [ContactKey: Double] = [:]
    public var counts: [ContactKey: Int] = [:]
    public var recentEvents: [EstimatedStrike] = []
    public var processedFrames = 0
    public init() {}
}

private struct Vector: Sendable {
    let x: Double
    let y: Double
    var length: Double { hypot(x, y) }
    static func - (a: Self, b: Self) -> Self { Self(x: a.x - b.x, y: a.y - b.y) }
    func dot(_ other: Self) -> Double { x * other.x + y * other.y }
    func divided(by value: Double) -> Self { Self(x: x / value, y: y / value) }
    init(x: Double, y: Double) { self.x = x; self.y = y }
    init(_ p: NormalizedPoint) { x = p.x; y = p.y }
}

private struct ContactSample: Sendable {
    let feature: Vector
    let wrist: Vector
    let axis: Vector
    let scale: Double
    let confidence: Double

    init?(hand: HandObservation, contact: DrumContact, area: PlayingArea) {
        let joints = hand.visibleJoints(minimumConfidence: 0.72)
        guard let wrist = joints[.wrist], let middle = joints[.middleMCP] else { return nil }
        let axis = Vector(middle.point) - Vector(wrist.point)
        guard axis.length >= 0.025 else { return nil }
        let point: NormalizedPoint
        if let tip = contact.tip {
            guard let sample = joints[tip] else { return nil }
            point = sample.point
            confidence = min(wrist.confidence, middle.confidence, sample.confidence)
        } else {
            guard let palm = hand.palmProxy(minimumConfidence: 0.72) else { return nil }
            point = palm
            let anchors: [HandJoint] = [.wrist, .indexMCP, .middleMCP, .ringMCP, .littleMCP]
            confidence = anchors.compactMap { joints[$0]?.confidence }.min() ?? 0
        }
        guard area.tableCoordinates(of: point) != nil else { return nil }
        self.wrist = Vector(wrist.point)
        self.axis = axis.divided(by: axis.length)
        scale = axis.length
        // Fingers use wrist-relative, palm-size-normalized displacement to reject
        // whole-hand translation. Palm intentionally uses an absolute proxy.
        feature = contact == .palm ? Vector(point) : (Vector(point) - self.wrist).divided(by: scale)
    }

    init(feature: Vector, wrist: Vector, axis: Vector, scale: Double, confidence: Double) {
        self.feature = feature; self.wrist = wrist; self.axis = axis
        self.scale = scale; self.confidence = confidence
    }

    func matchesPose(_ reference: Self, palm: Bool, duringCollection: Bool = false) -> Bool {
        let ratio = scale / reference.scale
        return (0.8...1.25).contains(ratio) && axis.dot(reference.axis) >= 0.94
            && (palm && !duringCollection || (wrist - reference.wrist).length <= (duringCollection ? 0.03 : 0.08))
    }
}

/// Streaming sums only; no frame/landmark trajectory is stored.
private struct ReferenceWindow: Sendable {
    let first: ContactSample
    let started: Double
    var count = 0
    var x = 0.0, y = 0.0, square = 0.0
    var wx = 0.0, wy = 0.0, ax = 0.0, ay = 0.0, scale = 0.0
    var confidence = 1.0
    mutating func append(_ sample: ContactSample) {
        count += 1
        x += sample.feature.x; y += sample.feature.y
        square += sample.feature.dot(sample.feature)
        wx += sample.wrist.x; wy += sample.wrist.y
        ax += sample.axis.x; ay += sample.axis.y; scale += sample.scale
        confidence = min(confidence, sample.confidence)
    }
    var mean: ContactSample {
        let n = Double(count)
        let axis = Vector(x: ax / n, y: ay / n)
        return ContactSample(feature: Vector(x: x / n, y: y / n), wrist: Vector(x: wx / n, y: wy / n),
                             axis: axis.divided(by: axis.length), scale: scale / n, confidence: confidence)
    }
    var noise: Double {
        sqrt(max(0, square / Double(count) - mean.feature.dot(mean.feature)))
    }
}

private struct ContactReference: Sendable {
    let rest: ContactSample
    let restNoise: Double
    var lifted: ContactSample?
    var version = 0

    func level(for sample: ContactSample, palm: Bool) -> Double? {
        guard let lifted, sample.matchesPose(rest, palm: palm) else { return nil }
        let direction = lifted.feature - rest.feature
        let displacement = sample.feature - rest.feature
        let level = displacement.dot(direction) / direction.dot(direction)
        let residual = Vector(x: displacement.x - level * direction.x, y: displacement.y - level * direction.y)
        guard residual.length <= max(palm ? 0.008 : 0.04, direction.length * 0.35) else { return nil }
        return level
    }
}

/// Queue-confined by the app. All mutations and recognition run at accepted frame rate.
public struct StrikeExperiment: Sendable {
    public private(set) var readout = StrikeReadout()
    private var area: PlayingArea?
    private var references: [ContactKey: ContactReference] = [:]
    private var detectors: [ContactKey: StrikeDetector] = [:]
    private var collecting: (key: ContactKey, lifted: Bool)?
    private var window: ReferenceWindow?
    private var lastTime: Double?
    private var collectionStart: Double?
    private var nextEventID = 1
    private var nextCalibrationVersion = 1

    public init(area: PlayingArea? = nil) {
        self.area = area
        readout.areaAvailable = area != nil
    }

    public mutating func beginReference(key: ContactKey, lifted: Bool) {
        guard area != nil, key.hand != .unknown else { return }
        guard !lifted || references[key] != nil else {
            readout.message = "Learn a resting reference first."; return
        }
        setEnabled(false)
        if !lifted { references[key] = nil; readout.restKeys.remove(key) }
        else { references[key]?.lifted = nil }
        readout.readyKeys.remove(key)
        collecting = (key, lifted)
        window = nil
        collectionStart = nil
        readout.collecting = true
        readout.message = "Hold \(key.label) \(lifted ? "lifted" : "resting on the table") steadily for 0.5 s."
    }

    public mutating func setEnabled(_ enabled: Bool) {
        readout.enabled = enabled && !readout.readyKeys.isEmpty && collecting == nil
        detectors = [:]
        readout.states = [:]
        readout.levels = [:]
        if !readout.enabled { readout.message = "Detection paused. References remain for this capture run." }
        else { readout.message = "Experimental detection enabled. Lift each calibrated contact to arm." }
    }

    public mutating func clearEvents() {
        readout.counts = [:]
        readout.recentEvents = []
        // IDs remain unique within the experiment even after clearing counters.
    }

    public mutating func suspend(_ reason: String) {
        collecting = nil; window = nil; collectionStart = nil
        readout.collecting = false
        setEnabled(false)
        readout.message = reason
    }

    public mutating func consume(hands: [HandObservation], sourceTime: Double, hostTime: Double) {
        guard sourceTime.isFinite, hostTime.isFinite else { suspend("Invalid frame clock; detection paused."); return }
        if let lastTime, sourceTime <= lastTime { return }
        if let lastTime, sourceTime - lastTime > 0.25 {
            self = StrikeExperiment()
            readout.message = "Frame gap exceeded 250 ms. Set the area and references again."
        } else if let lastTime, sourceTime - lastTime > 0.1 {
            detectors = [:]; window = nil
            readout.states = [:]; readout.levels = [:]
        }
        lastTime = sourceTime
        guard let area else { return }
        readout.processedFrames += 1
        if let collecting {
            collect(collecting.key, lifted: collecting.lifted, hands: hands, area: area, time: sourceTime)
            return
        }
        guard readout.enabled else { return }
        for key in readout.readyKeys.sorted(by: {
            ($0.hand.rawValue, $0.contact.rawValue) < ($1.hand.rawValue, $1.contact.rawValue)
        }) {
            let sample = uniqueSample(for: key, hands: hands, area: area)
            let level = sample.flatMap { references[key]?.level(for: $0, palm: key.contact == .palm) }
            var detector = detectors[key] ?? StrikeDetector()
            if let evidence = detector.consume(level: level, sourceTime: sourceTime), let sample {
                let event = EstimatedStrike(id: nextEventID, key: key, evidence: evidence,
                                            recognizedHostTime: hostTime,
                                            calibrationVersion: references[key]?.version ?? 0,
                                            landmarkConfidence: sample.confidence)
                nextEventID += 1
                readout.counts[key, default: 0] += 1
                readout.recentEvents.append(event)
                if readout.recentEvents.count > 32 { readout.recentEvents.removeFirst() }
            }
            detectors[key] = detector
            readout.levels[key] = level
            readout.states[key] = level == nil ? "Uncertain / reposition or recalibrate" : detector.state.rawValue
        }
    }

    private func uniqueSample(for key: ContactKey, hands: [HandObservation], area: PlayingArea) -> ContactSample? {
        let matches = hands.filter { $0.handedness == key.hand }
        guard matches.count == 1 else { return nil } // Unknown/duplicate identity never drives a contact.
        return ContactSample(hand: matches[0], contact: key.contact, area: area)
    }

    private mutating func collect(_ key: ContactKey, lifted: Bool, hands: [HandObservation], area: PlayingArea, time: Double) {
        if collectionStart == nil { collectionStart = time }
        if time - (collectionStart ?? time) > 4 {
            suspend("Reference timed out. Keep the hand visible and steady, then retry."); return
        }
        guard let sample = uniqueSample(for: key, hands: hands, area: area) else {
            window = nil
            readout.message = "Need one clear \(key.hand.rawValue) hand, confidence ≥0.72, inside the area."
            return
        }
        if let current = window, !sample.matchesPose(current.first, palm: key.contact == .palm, duringCollection: true) {
            window = nil
        }
        if window == nil { window = ReferenceWindow(first: sample, started: time) }
        window?.append(sample)
        guard let current = window else { return }
        readout.message = "Hold \(key.label) \(lifted ? "lifted" : "resting"): \(current.count) samples…"
        guard current.count >= 12, time - current.started >= 0.5 else { return }
        let mean = current.mean
        let maxNoise = key.contact == .palm ? 0.004 : 0.035
        guard current.noise <= maxNoise else {
            suspend("Reference moved too much. Retry holding still."); return
        }
        if lifted {
            guard var reference = references[key], mean.matchesPose(reference.rest, palm: key.contact == .palm) else {
                suspend("Hand position changed between references. Learn rest again."); return
            }
            let separation = (mean.feature - reference.rest.feature).length
            guard separation >= (key.contact == .palm ? 0.012 : 0.12),
                  separation >= 6 * max(current.noise, reference.restNoise) else {
                suspend("Rest/lift separation is too small or noisy. Lift clearly and retry."); return
            }
            reference.lifted = mean
            reference.version = nextCalibrationVersion
            nextCalibrationVersion += 1
            references[key] = reference
            readout.readyKeys.insert(key)
            readout.message = "\(key.label) ready. Enable detection, then lift to arm."
        } else {
            references[key] = ContactReference(rest: mean, restNoise: current.noise)
            readout.restKeys.insert(key)
            readout.message = "\(key.label) rest learned. Now lift this contact and learn lifted."
        }
        collecting = nil; window = nil; collectionStart = nil
        readout.collecting = false
    }
}
