import XCTest
@testable import TapDrumCore

final class PreviewProjectionTests: XCTestCase {
    func testWristAboveFingertipsStaysAboveInUnflippedOverlay() {
        let projection = PreviewProjection(x: 0, y: 0, width: 1280, height: 720)!
        let wrist = projection.project(NormalizedPoint(x: 0.5, y: 0.8)!, mirrored: false)
        let tip = projection.project(NormalizedPoint(x: 0.5, y: 0.2)!, mirrored: false)
        XCTAssertGreaterThan(wrist.y, tip.y)
        XCTAssertEqual(wrist.y, 576, accuracy: 1e-10)
        XCTAssertEqual(720 - wrist.y, 144, accuracy: 1e-10) // Screen distance from top.
        XCTAssertEqual(720 - tip.y, 576, accuracy: 1e-10)
    }

    func testCornersAndCenterRespectLetterboxOffsets() {
        let projection = PreviewProjection(x: 100, y: 50, width: 800, height: 450)!
        let bottomLeft = projection.project(NormalizedPoint(x: 0, y: 0)!, mirrored: false)
        let topRight = projection.project(NormalizedPoint(x: 1, y: 1)!, mirrored: false)
        let center = projection.project(NormalizedPoint(x: 0.5, y: 0.5)!, mirrored: false)
        XCTAssertEqual(bottomLeft.x, 100)
        XCTAssertEqual(bottomLeft.y, 50)
        XCTAssertEqual(topRight.x, 900)
        XCTAssertEqual(topRight.y, 500)
        XCTAssertEqual(center.x, 500)
        XCTAssertEqual(center.y, 275)
    }

    func testMirroringChangesOnlyHorizontalPlacement() {
        let projection = PreviewProjection(x: 10, y: 20, width: 1000, height: 600)!
        let point = NormalizedPoint(x: 0.2, y: 0.8)!
        let original = projection.project(point, mirrored: false)
        let mirrored = projection.project(point, mirrored: true)
        XCTAssertEqual(original.x, 210)
        XCTAssertEqual(mirrored.x, 810)
        XCTAssertEqual(original.y, mirrored.y)
    }

    func testProjectionRoundTripsWithMirroringAndLetterboxing() {
        let projection = PreviewProjection(x: 40, y: 90, width: 960, height: 540)!
        for mirrored in [false, true] {
            for point in [NormalizedPoint(x: 0.1, y: 0.9)!, NormalizedPoint(x: 0.8, y: 0.3)!] {
                let pixel = projection.project(point, mirrored: mirrored)
                let restored = projection.unproject(x: pixel.x, y: pixel.y, mirrored: mirrored)!
                XCTAssertEqual(restored.x, point.x, accuracy: 1e-10)
                XCTAssertEqual(restored.y, point.y, accuracy: 1e-10)
            }
        }
    }

    func testLetterboxAndInvalidClicksAreRejected() {
        let projection = PreviewProjection(x: 100, y: 50, width: 800, height: 450)!
        XCTAssertNil(projection.unproject(x: 99, y: 100, mirrored: false))
        XCTAssertNil(projection.unproject(x: 500, y: 501, mirrored: true))
        XCTAssertNil(projection.unproject(x: .nan, y: 100, mirrored: false))
    }

    func testInvalidImageRectanglesAreRejected() {
        XCTAssertNil(PreviewProjection(x: 0, y: 0, width: 0, height: 10))
        XCTAssertNil(PreviewProjection(x: 0, y: 0, width: 10, height: -1))
        XCTAssertNil(PreviewProjection(x: .nan, y: 0, width: 10, height: 10))
        XCTAssertNil(PreviewProjection(x: 0, y: 0, width: .infinity, height: 10))
    }
}
