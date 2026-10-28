import XCTest
@testable import TapDrumCore

final class StrikeExperimentTests: XCTestCase {
    private let key = ContactKey(hand: .right, contact: .index)
    private var area: PlayingArea {
        PlayingArea(corners: [(0.01, 0.01), (0.99, 0.01), (0.99, 0.99), (0.01, 0.99)]
            .map { NormalizedPoint(x: $0.0, y: $0.1)! })!
    }

    private func hand(_ side: Handedness = .right, levels: [DrumContact: Double] = [:],
                      confidence: Double = 0.95, shift: Double = 0, sideways: Double = 0) -> HandObservation {
        let wristX = side == .left ? 0.25 : 0.6
        var joints: [HandJoint: HandLandmark] = [:]
        func joint(_ name: HandJoint, _ x: Double, _ y: Double) {
            joints[name] = HandLandmark(point: NormalizedPoint(x: x + sideways, y: y + shift)!, confidence: confidence)!
        }
        joint(.wrist, wristX, 0.25)
        joint(.indexMCP, wristX - 0.03, 0.4)
        joint(.middleMCP, wristX, 0.4)
        joint(.ringMCP, wristX + 0.03, 0.39)
        joint(.littleMCP, wristX + 0.06, 0.38)
        for contact in DrumContact.allCases {
            if let tip = contact.tip { joint(tip, wristX, 0.55 + 0.12 * levels[contact, default: 0]) }
        }
        return HandObservation(handedness: side, joints: joints)
    }

    private func feed(_ experiment: inout StrikeExperiment, _ hands: [HandObservation], time: inout Double) {
        experiment.consume(hands: hands, sourceTime: time, hostTime: 1000 + time)
        time += 1.0 / 30
    }

    private func calibrate(_ experiment: inout StrikeExperiment, key: ContactKey, time: inout Double) {
        for lifted in [false, true] {
            experiment.beginReference(key: key, lifted: lifted)
            for _ in 0..<18 {
                let pose = key.contact == .palm
                    ? hand(key.hand, shift: lifted ? 0.04 : 0)
                    : hand(key.hand, levels: [key.contact: lifted ? 1 : 0])
                feed(&experiment, [pose], time: &time)
            }
        }
        XCTAssertTrue(experiment.readout.readyKeys.contains(key), experiment.readout.message)
    }

    func testReferenceNeedsAreaKnownHandAndRestBeforeLift() {
        var experiment = StrikeExperiment()
        experiment.beginReference(key: key, lifted: false)
        XCTAssertFalse(experiment.readout.collecting)
        experiment = StrikeExperiment(area: area)
        experiment.beginReference(key: key, lifted: true)
        XCTAssertFalse(experiment.readout.collecting)
        experiment.beginReference(key: ContactKey(hand: .unknown, contact: .index), lifted: false)
        XCTAssertFalse(experiment.readout.collecting)
    }

    func testSteadyReferencesThenApproachAtFullFrameRateProduceTimestampedEvent() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        experiment.setEnabled(true)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] {
            feed(&experiment, [hand(levels: [.index: level])], time: &time)
        }
        XCTAssertEqual(experiment.readout.counts[key], 1)
        XCTAssertEqual(experiment.readout.recentEvents.count, 1)
        let event = experiment.readout.recentEvents[0]
        XCTAssertEqual(event.key, key)
        XCTAssertEqual(event.landmarkConfidence, 0.95)
        XCTAssertGreaterThan(event.recognizedHostTime, 1000)
        XCTAssertGreaterThan(event.evidence.evidenceDelayMS, 0)
        XCTAssertEqual(event.calibrationVersion, 1)
        XCTAssertEqual(experiment.readout.processedFrames, 42)
    }

    func testSmallAndNoisyReferenceSeparationIsRejected() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        experiment.beginReference(key: key, lifted: false)
        for _ in 0..<18 { feed(&experiment, [hand()], time: &time) }
        experiment.beginReference(key: key, lifted: true)
        for _ in 0..<18 { feed(&experiment, [hand(levels: [.index: 0.05])], time: &time) }
        XCTAssertFalse(experiment.readout.readyKeys.contains(key))
        XCTAssertTrue(experiment.readout.message.contains("too small"))
        experiment.beginReference(key: key, lifted: true)
        for i in 0..<18 { feed(&experiment, [hand(levels: [.index: i % 2 == 0 ? 1 : 0.5])], time: &time) }
        XCTAssertFalse(experiment.readout.readyKeys.contains(key))
        XCTAssertTrue(experiment.readout.message.contains("moved too much"))
    }

    func testMissingOrAmbiguousIdentityTimesOutReference() {
        var experiment = StrikeExperiment(area: area)
        experiment.beginReference(key: key, lifted: false)
        var time = 0.0
        for _ in 0..<125 { feed(&experiment, [hand(), hand()], time: &time) }
        XCTAssertFalse(experiment.readout.collecting)
        XCTAssertTrue(experiment.readout.message.contains("timed out"))
        XCTAssertTrue(experiment.readout.restKeys.isEmpty)
    }

    func testBothHandsAndContactsCanConfirmInTheSameFrame() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        let left = ContactKey(hand: .left, contact: .middle)
        calibrate(&experiment, key: key, time: &time)
        calibrate(&experiment, key: left, time: &time)
        experiment.setEnabled(true)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] {
            feed(&experiment, [hand(levels: [.index: level]), hand(.left, levels: [.middle: level])], time: &time)
        }
        XCTAssertEqual(experiment.readout.counts[key], 1)
        XCTAssertEqual(experiment.readout.counts[left], 1)
        let events = experiment.readout.recentEvents
        XCTAssertEqual(events[0].evidence.confirmationSourceTime, events[1].evidence.confirmationSourceTime)
        XCTAssertNotEqual(events[0].id, events[1].id)
        XCTAssertEqual(events.map(\.key), [left, key]) // Stable simultaneous-event ordering.
    }

    func testLowConfidenceUnknownHandAndTrackingLossCannotTriggerOnReacquisition() {
        for invalid in [hand(confidence: 0.5), hand(.unknown), hand(shift: 0.13), hand(sideways: 0.13)] {
            var experiment = StrikeExperiment(area: area)
            var time = 0.0
            calibrate(&experiment, key: key, time: &time)
            experiment.setEnabled(true)
            for level in [1.0, 1, 0.6] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
            feed(&experiment, [invalid], time: &time)
            for level in [0.0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
            XCTAssertTrue(experiment.readout.recentEvents.isEmpty)
        }
    }

    func testGapInvalidatesAreaReferencesAndDetection() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        experiment.setEnabled(true)
        time += 0.3
        feed(&experiment, [hand()], time: &time)
        XCTAssertFalse(experiment.readout.areaAvailable)
        XCTAssertFalse(experiment.readout.enabled)
        XCTAssertTrue(experiment.readout.readyKeys.isEmpty)
    }

    func testPauseAndClearCountersDoNotAutoEnableAndEventsStayBounded() throws {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        XCTAssertFalse(experiment.readout.enabled)
        experiment.setEnabled(true)
        for _ in 0..<45 {
            for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        }
        XCTAssertEqual(experiment.readout.counts[key], 45)
        XCTAssertEqual(experiment.readout.recentEvents.count, 32)
        let lastID = try XCTUnwrap(experiment.readout.recentEvents.last).id
        experiment.clearEvents()
        XCTAssertTrue(experiment.readout.recentEvents.isEmpty)
        XCTAssertTrue(experiment.readout.counts.isEmpty)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        XCTAssertGreaterThan(try XCTUnwrap(experiment.readout.recentEvents.last).id, lastID)
        experiment.setEnabled(false)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        XCTAssertEqual(experiment.readout.counts[key], 1)
        XCTAssertTrue(experiment.readout.readyKeys.contains(key))
    }

    func testPalmProxyUsesAbsoluteMotionRatherThanFingerRelativeMotion() {
        let palm = ContactKey(hand: .right, contact: .palm)
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: palm, time: &time)
        experiment.setEnabled(true)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [hand(shift: 0.04 * level)], time: &time) }
        XCTAssertEqual(experiment.readout.counts[palm], 1)
    }

    func testFingerReferenceIgnoresSmallWholeHandTranslation() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        experiment.setEnabled(true)
        for shift in [0.06, 0.06, 0.04, 0.01, 0, 0.01] {
            feed(&experiment, [hand(shift: shift)], time: &time)
        }
        XCTAssertTrue(experiment.readout.recentEvents.isEmpty)
    }

    func testEveryFingerAndPalmSlotCanLearnIndependentReferences() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        for side in [Handedness.left, .right] {
            for contact in DrumContact.allCases {
                calibrate(&experiment, key: ContactKey(hand: side, contact: contact), time: &time)
            }
        }
        XCTAssertEqual(experiment.readout.readyKeys.count, 12)
        experiment.beginReference(key: key, lifted: false)
        XCTAssertFalse(experiment.readout.readyKeys.contains(key))
        XCTAssertFalse(experiment.readout.enabled)
        XCTAssertEqual(experiment.readout.readyKeys.count, 11)
    }

    func testLiftDirectionCanBeObliqueInsteadOfImageVertical() {
        func oblique(_ level: Double) -> HandObservation {
            let base = hand()
            var joints = base.joints
            joints[.indexTip] = HandLandmark(point: NormalizedPoint(x: 0.6 + 0.08 * level, y: 0.55 + 0.05 * level)!, confidence: 0.95)!
            return HandObservation(handedness: .right, joints: joints)
        }
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        for lifted in [false, true] {
            experiment.beginReference(key: key, lifted: lifted)
            for _ in 0..<18 { feed(&experiment, [oblique(lifted ? 1 : 0)], time: &time) }
        }
        experiment.setEnabled(true)
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [oblique(level)], time: &time) }
        XCTAssertEqual(experiment.readout.counts[key], 1)
    }

    func testOffPathMotionAndOutsideAreaCannotSupplyStrikeEvidence() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        experiment.setEnabled(true)
        for level in [1.0, 1, 0.6] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        var joints = hand().joints
        joints[.indexTip] = HandLandmark(point: NormalizedPoint(x: 0.9, y: 0.55)!, confidence: 0.95)!
        feed(&experiment, [HandObservation(handedness: .right, joints: joints)], time: &time)
        for level in [0.0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        XCTAssertTrue(experiment.readout.recentEvents.isEmpty)
        let small = PlayingArea(corners: [(0.1, 0.1), (0.4, 0.1), (0.4, 0.9), (0.1, 0.9)]
            .map { NormalizedPoint(x: $0.0, y: $0.1)! })!
        experiment = StrikeExperiment(area: small)
        experiment.beginReference(key: key, lifted: false)
        for _ in 0..<18 { feed(&experiment, [hand()], time: &time) }
        XCTAssertTrue(experiment.readout.restKeys.isEmpty)
    }

    func testPauseForInvalidClockRequiresExplicitEnableAndFreshLift() {
        var experiment = StrikeExperiment(area: area)
        var time = 0.0
        calibrate(&experiment, key: key, time: &time)
        experiment.setEnabled(true)
        experiment.consume(hands: [hand()], sourceTime: time, hostTime: .nan)
        XCTAssertFalse(experiment.readout.enabled)
        XCTAssertTrue(experiment.readout.readyKeys.contains(key))
        for level in [1.0, 1, 0.6, 0.15, 0, 0.1] { feed(&experiment, [hand(levels: [.index: level])], time: &time) }
        XCTAssertTrue(experiment.readout.recentEvents.isEmpty)
    }
}
