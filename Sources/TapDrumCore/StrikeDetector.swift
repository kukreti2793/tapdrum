import Foundation

/// Experimental motion evidence, never a physical-contact measurement.
public struct StrikeEvidence: Sendable {
    public let candidateSourceTime: Double
    public let confirmationSourceTime: Double
    public let approachSpeed: Double
    public var evidenceDelayMS: Double { (confirmationSourceTime - candidateSourceTime) * 1000 }
}

/// Input is calibrated projected displacement: rest = 0, lifted = 1.
/// Only the previous sample and a candidate extremum are retained.
public struct StrikeDetector: Sendable {
    public enum State: String, Sendable {
        case needsRelease = "Lift to arm"
        case armed = "Armed"
        case approaching = "Approaching"
        case candidate = "Awaiting reversal"
    }

    public private(set) var state: State = .needsRelease
    private var previous: (time: Double, level: Double)?
    private var lastSourceTime: Double?
    private var releaseSince: Double?
    private var approachSince: Double?
    private var candidateTime: Double?
    private var minimumLevel = Double.infinity
    private var peakSpeed = 0.0
    private var lastEventTime = -Double.infinity

    public init() {}

    public mutating func loseTracking() {
        state = .needsRelease
        previous = nil
        releaseSince = nil
        approachSince = nil
        candidateTime = nil
        peakSpeed = 0
        minimumLevel = .infinity
    }

    public mutating func consume(level: Double?, sourceTime: Double) -> StrikeEvidence? {
        guard sourceTime.isFinite else { loseTracking(); return nil }
        // A duplicate/older sample cannot rewind state or produce an event.
        if let lastSourceTime, sourceTime <= lastSourceTime { return nil }
        lastSourceTime = sourceTime
        guard let level, level.isFinite, (-0.35...1.8).contains(level) else {
            loseTracking(); return nil
        }
        if let old = previous, sourceTime - old.time > 0.1 { loseTracking() }
        let speed = previous.map { (level - $0.level) / (sourceTime - $0.time) } ?? 0
        previous = (sourceTime, level)

        switch state {
        case .needsRelease:
            if level >= 0.65 {
                if let since = releaseSince, sourceTime - since >= 0.025,
                   sourceTime - lastEventTime >= 0.06 {
                    state = .armed
                    releaseSince = nil
                } else if releaseSince == nil { releaseSince = sourceTime }
            } else { releaseSince = nil }
        case .armed:
            if speed <= -3 {
                state = .approaching
                approachSince = sourceTime
                peakSpeed = -speed
                if level <= 0.2 { beginCandidate(at: sourceTime, level: level) }
            }
        case .approaching:
            peakSpeed = max(peakSpeed, -speed)
            if sourceTime - (approachSince ?? sourceTime) > 0.35 || speed > 0.5 {
                loseTracking()
            } else if level <= 0.2 {
                beginCandidate(at: sourceTime, level: level)
            }
        case .candidate:
            peakSpeed = max(peakSpeed, -speed)
            minimumLevel = min(minimumLevel, level)
            if sourceTime - (candidateTime ?? sourceTime) > 0.12 {
                loseTracking()
            } else if level - minimumLevel >= 0.08, speed > 0,
                      let candidateTime {
                let evidence = StrikeEvidence(candidateSourceTime: candidateTime,
                                              confirmationSourceTime: sourceTime,
                                              approachSpeed: peakSpeed)
                lastEventTime = sourceTime
                loseTracking() // A new credible lift is mandatory, even after refractory time.
                return evidence
            }
        }
        return nil
    }

    private mutating func beginCandidate(at time: Double, level: Double) {
        state = .candidate
        candidateTime = time
        minimumLevel = level
    }
}
