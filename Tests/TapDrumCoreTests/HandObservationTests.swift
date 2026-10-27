import XCTest
@testable import TapDrumCore

final class HandObservationTests: XCTestCase {
    func testInvalidCoordinatesAndConfidenceAreRejectedRatherThanClamped() {
        XCTAssertNil(NormalizedPoint(x: .nan, y: 0))
        XCTAssertNil(NormalizedPoint(x: 0, y: .infinity))
        XCTAssertNil(NormalizedPoint(x: -0.01, y: 0.5))
        XCTAssertNil(NormalizedPoint(x: 0.5, y: 1.01))
        let point = NormalizedPoint(x: 0, y: 1)!
        XCTAssertNil(HandLandmark(point: point, confidence: .nan))
        XCTAssertNil(HandLandmark(point: point, confidence: 1.1))
    }

    func testVisionCoordinatesConvertToCaptureDeviceOrigin() {
        XCTAssertEqual(NormalizedPoint(x: 0.2, y: 0.8)!.captureDeviceY, 0.2, accuracy: 1e-10)
        XCTAssertEqual(NormalizedPoint(x: 0, y: 0)!.captureDeviceY, 1)
        XCTAssertEqual(NormalizedPoint(x: 1, y: 1)!.captureDeviceY, 0)
        // Preview mirroring is deliberately not applied to anatomical identity.
        XCTAssertEqual(Handedness.left.label, "Left (estimate)")
    }

    func testLowConfidenceAndMissingJointsDoNotBecomeVisiblePoints() {
        let point = NormalizedPoint(x: 0.4, y: 0.6)!
        let hand = HandObservation(handedness: .unknown, joints: [
            .wrist: HandLandmark(point: point, confidence: 0.9)!,
            .indexTip: HandLandmark(point: point, confidence: 0.1)!
        ])
        XCTAssertEqual(Set(hand.visibleJoints(minimumConfidence: 0.3).keys), [.wrist])
        XCTAssertTrue(hand.visibleJoints(minimumConfidence: .nan).isEmpty)
        XCTAssertEqual(hand.meanJointConfidence!, 0.5, accuracy: 1e-10)
        XCTAssertNil(HandObservation(handedness: .left, joints: [:]).meanJointConfidence)
        XCTAssertNil(hand.palmProxy(minimumConfidence: 0.3))
    }

    func testPalmProxyRequiresAllFiveConfidentAnchors() {
        let anchors: [HandJoint] = [.wrist, .indexMCP, .middleMCP, .ringMCP, .littleMCP]
        var joints: [HandJoint: HandLandmark] = [:]
        for (index, joint) in anchors.enumerated() {
            joints[joint] = HandLandmark(point: NormalizedPoint(x: Double(index) / 4, y: 0.4)!, confidence: 0.8)!
        }
        let complete = HandObservation(handedness: .right, joints: joints)
        XCTAssertEqual(complete.palmProxy(minimumConfidence: 0.3)!.x, 0.5, accuracy: 1e-10)
        joints[.wrist] = HandLandmark(point: NormalizedPoint(x: 0, y: 0.4)!, confidence: 0.1)!
        XCTAssertNil(HandObservation(handedness: .right, joints: joints).palmProxy(minimumConfidence: 0.3))
    }

    func testSkeletonCoversEveryJointWithoutConnectingDifferentFingers() {
        XCTAssertEqual(HandJoint.allCases.count, 21)
        XCTAssertEqual(Set(HandJoint.fingerChains.flatMap { $0 }), Set(HandJoint.allCases))
        XCTAssertEqual(HandJoint.fingerChains.count, 5)
        XCTAssertTrue(HandJoint.fingerChains.allSatisfy { $0.first == .wrist && $0.count == 5 })
        XCTAssertEqual(Set(HandJoint.fingerChains.map { $0.last! }), [.thumbTip, .indexTip, .middleTip, .ringTip, .littleTip])
    }
}
