public struct NormalizedPoint: Equatable, Sendable {
    public let x: Double
    public let y: Double

    public init?(x: Double, y: Double) {
        guard x.isFinite, y.isFinite, (0...1).contains(x), (0...1).contains(y) else { return nil }
        self.x = x
        self.y = y
    }

    /// Vision's lower-left origin -> AVFoundation capture-device upper-left origin.
    /// Preview-layer conversion handles aspect fit, rotation and mirroring later.
    public var captureDeviceY: Double { 1 - y }
}

public enum Handedness: String, Sendable {
    case left, right, unknown

    public var label: String { rawValue.capitalized + " (estimate)" }
}

public enum HandJoint: String, CaseIterable, Sendable {
    case wrist
    case thumbCMC, thumbMP, thumbIP, thumbTip
    case indexMCP, indexPIP, indexDIP, indexTip
    case middleMCP, middlePIP, middleDIP, middleTip
    case ringMCP, ringPIP, ringDIP, ringTip
    case littleMCP, littlePIP, littleDIP, littleTip

    public static let fingerChains: [[HandJoint]] = [
        [.wrist, .thumbCMC, .thumbMP, .thumbIP, .thumbTip],
        [.wrist, .indexMCP, .indexPIP, .indexDIP, .indexTip],
        [.wrist, .middleMCP, .middlePIP, .middleDIP, .middleTip],
        [.wrist, .ringMCP, .ringPIP, .ringDIP, .ringTip],
        [.wrist, .littleMCP, .littlePIP, .littleDIP, .littleTip]
    ]
}

public struct HandLandmark: Equatable, Sendable {
    public let point: NormalizedPoint
    public let confidence: Double

    public init?(point: NormalizedPoint, confidence: Double) {
        guard confidence.isFinite, (0...1).contains(confidence) else { return nil }
        self.point = point
        self.confidence = confidence
    }
}

public struct HandObservation: Sendable {
    public let handedness: Handedness
    public let joints: [HandJoint: HandLandmark]

    public init(handedness: Handedness, joints: [HandJoint: HandLandmark]) {
        self.handedness = handedness
        self.joints = joints
    }

    public func visibleJoints(minimumConfidence: Double) -> [HandJoint: HandLandmark] {
        guard minimumConfidence.isFinite, (0...1).contains(minimumConfidence) else { return [:] }
        return joints.filter { $0.value.confidence >= minimumConfidence }
    }

    /// Mean of actual returned joint confidences, not a calibrated strike score.
    public var meanJointConfidence: Double? {
        guard !joints.isEmpty else { return nil }
        return joints.values.reduce(0) { $0 + $1.confidence } / Double(joints.count)
    }

    /// An illustrative palm-center proxy; requires all five anchors to be usable.
    /// This does not locate the physical palm-base contact patch or table plane.
    public func palmProxy(minimumConfidence: Double) -> NormalizedPoint? {
        let usable = visibleJoints(minimumConfidence: minimumConfidence)
        let anchors: [HandJoint] = [.wrist, .indexMCP, .middleMCP, .ringMCP, .littleMCP]
        let points = anchors.compactMap { usable[$0]?.point }
        guard points.count == anchors.count else { return nil }
        return NormalizedPoint(
            x: points.reduce(0) { $0 + $1.x } / Double(points.count),
            y: points.reduce(0) { $0 + $1.y } / Double(points.count)
        )
    }
}
