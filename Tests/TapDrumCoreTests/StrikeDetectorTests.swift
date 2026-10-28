import XCTest
@testable import TapDrumCore

final class StrikeDetectorTests: XCTestCase {
    private func play(_ levels: [Double?], step: Double = 1.0 / 30) -> [StrikeEvidence] {
        var detector = StrikeDetector()
        return levels.enumerated().compactMap { index, level in
            detector.consume(level: level, sourceTime: Double(index) * step)
        }
    }

    func testApproachAndReversalProduceOneEventWithEvidenceDelay() {
        let events = play([1, 1, 0.6, 0.15, 0, 0.1, 0, 0.1, 0, 0.1])
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0].candidateSourceTime, 0.1, accuracy: 1e-9)
        XCTAssertEqual(events[0].confirmationSourceTime, 5.0 / 30, accuracy: 1e-9)
        XCTAssertEqual(events[0].evidenceDelayMS, 200.0 / 3, accuracy: 1e-8)
        XCTAssertGreaterThan(events[0].approachSpeed, 3)
    }

    func testRestHoverLiftAndApproachWithoutNearRestReversalDoNotTrigger() {
        XCTAssertTrue(play(Array(repeating: 0, count: 100)).isEmpty)
        XCTAssertTrue(play(Array(repeating: 1, count: 100)).isEmpty)
        XCTAssertTrue(play([0, 0.2, 0.5, 0.8, 1, 1]).isEmpty)
        XCTAssertTrue(play([1, 1, 0.7, 0.4, 0.55, 1, 1]).isEmpty)
    }

    func testRestEntryWithoutReleaseCannotTrigger() {
        XCTAssertTrue(play([0.5, 0.2, 0, 0.15, 0.2]).isEmpty)
    }

    func testFreshReleaseAllowsRepeatButRestBounceCannotRetrigger() {
        let one: [Double?] = [1, 1, 0.6, 0.15, 0, 0.1]
        XCTAssertEqual(play(one + [0, 0.12, 0, 0.12] + one).count, 2)
    }

    func testMissingConfidenceAndReacquiredImpactNeedNewRelease() {
        XCTAssertTrue(play([1, 1, 0.6, nil, 0, 0.15, 0]).isEmpty)
        XCTAssertEqual(play([1, 1, nil, 0, 0.1, 1, 1, 0.6, 0.15, 0, 0.1]).count, 1)
    }

    func testFrameGapDisarmsWithoutInventingVelocity() {
        var detector = StrikeDetector()
        _ = detector.consume(level: 1, sourceTime: 0)
        _ = detector.consume(level: 1, sourceTime: 0.033)
        XCTAssertNil(detector.consume(level: 0, sourceTime: 0.2))
        XCTAssertNil(detector.consume(level: 0.15, sourceTime: 0.233))
        XCTAssertEqual(detector.state, .needsRelease)
    }

    func testOldDuplicateInvalidAndOutOfCorridorInputCannotTrigger() {
        var detector = StrikeDetector()
        _ = detector.consume(level: 1, sourceTime: 1)
        _ = detector.consume(level: 1, sourceTime: 1.033)
        XCTAssertNil(detector.consume(level: 0, sourceTime: 1.033))
        XCTAssertNil(detector.consume(level: 0, sourceTime: 0.9))
        XCTAssertEqual(detector.state, .armed)
        XCTAssertNil(detector.consume(level: .nan, sourceTime: 1.066))
        XCTAssertNil(detector.consume(level: 0.2, sourceTime: 1.05))
        XCTAssertEqual(detector.state, .needsRelease)
        XCTAssertTrue(play([1, 1, -0.8, 0.15]).isEmpty)
    }

    func testSlowPlacementAndLongRestBeforeLiftAreRejected() {
        let slow = (0...40).map { Optional(1 - Double($0) / 40) }
        XCTAssertTrue(play([1, 1] + slow + [0.1]).isEmpty)
        XCTAssertTrue(play([1, 1, 0.6, 0.15, 0, 0, 0, 0, 0, 0.15]).isEmpty)
    }

    func testTimeBasedTransitionsAtThirtyAndSixtyFPS() {
        for fps in [30.0, 60.0] {
            var detector = StrikeDetector()
            var events: [StrikeEvidence] = []
            for index in 0...Int(fps * 0.3) {
                let t = Double(index) / fps
                let level = t < 0.08 ? 1 : t < 0.16 ? max(0, 1 - (t - 0.08) / 0.08) : min(1, (t - 0.16) / 0.1)
                if let event = detector.consume(level: level, sourceTime: t) { events.append(event) }
            }
            XCTAssertEqual(events.count, 1, "fps=\(fps)")
        }
    }
}
