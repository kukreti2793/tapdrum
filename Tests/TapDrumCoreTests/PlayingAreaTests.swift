import XCTest
@testable import TapDrumCore

final class PlayingAreaTests: XCTestCase {
    private func point(_ x: Double, _ y: Double) -> NormalizedPoint { NormalizedPoint(x: x, y: y)! }
    private var rectangle: [NormalizedPoint] { [point(0.1, 0.2), point(0.9, 0.2), point(0.9, 0.8), point(0.1, 0.8)] }
    private var perspective: [NormalizedPoint] { [point(0.1, 0.1), point(0.9, 0.1), point(0.7, 0.8), point(0.3, 0.8)] }

    func testAxisAlignedCornersAndCenterMapToUnitSquare() {
        let area = PlayingArea(corners: rectangle)!
        let expected = [point(0, 0), point(1, 0), point(1, 1), point(0, 1)]
        for (source, target) in zip(rectangle, expected) {
            let mapped = area.tableCoordinates(of: source)!
            XCTAssertEqual(mapped.x, target.x, accuracy: 1e-9)
            XCTAssertEqual(mapped.y, target.y, accuracy: 1e-9)
        }
        let center = area.tableCoordinates(of: point(0.5, 0.5))!
        XCTAssertEqual(center.x, 0.5, accuracy: 1e-9)
        XCTAssertEqual(center.y, 0.5, accuracy: 1e-9)
    }

    func testPerspectiveCenterUsesProjectiveNotBilinearInterpolation() {
        let area = PlayingArea(corners: perspective)!
        let center = area.imagePoint(at: point(0.5, 0.5))!
        XCTAssertEqual(center.x, 0.5, accuracy: 1e-9)
        XCTAssertEqual(center.y, 17.0 / 30.0, accuracy: 1e-9)
    }

    func testPerspectiveGridRoundTrips() {
        let area = PlayingArea(corners: perspective)!
        for x in [0.0, 0.25, 0.5, 0.75, 1] {
            for y in [0.0, 0.25, 0.5, 0.75, 1] {
                let source = point(x, y)
                let restored = area.tableCoordinates(of: area.imagePoint(at: source)!)!
                XCTAssertEqual(restored.x, x, accuracy: 1e-8)
                XCTAssertEqual(restored.y, y, accuracy: 1e-8)
            }
        }
    }

    func testOutsidePointsAreNotAdmittedByBoundaryTolerance() {
        let area = PlayingArea(corners: rectangle)!
        XCTAssertNil(area.tableCoordinates(of: point(0.099, 0.5)))
        XCTAssertNil(area.tableCoordinates(of: point(0.5, 0.801)))
        XCTAssertNotNil(area.tableCoordinates(of: point(0.1, 0.5)))
    }

    func testBothWindingsAreSupported() {
        for corners in [perspective, Array(perspective.reversed())] {
            let area = PlayingArea(corners: corners)!
            let restored = area.tableCoordinates(of: area.imagePoint(at: point(0.3, 0.7))!)!
            XCTAssertEqual(restored.x, 0.3, accuracy: 1e-9)
            XCTAssertEqual(restored.y, 0.7, accuracy: 1e-9)
        }
    }

    func testDegenerateConcaveAndCrossedRegionsAreRejected() {
        XCTAssertNil(PlayingArea(corners: Array(rectangle.prefix(3))))
        XCTAssertNil(PlayingArea(corners: [rectangle[0], rectangle[1], rectangle[1], rectangle[3]]))
        XCTAssertNil(PlayingArea(corners: [rectangle[0], rectangle[2], rectangle[1], rectangle[3]]))
        XCTAssertNil(PlayingArea(corners: [point(0.1, 0.1), point(0.9, 0.1), point(0.5, 0.2), point(0.1, 0.9)]))
        XCTAssertNil(PlayingArea(corners: [point(0.1, 0.1), point(0.2, 0.2), point(0.3, 0.3), point(0.4, 0.4)]))
        XCTAssertNil(PlayingArea(corners: [point(0.1, 0.1), point(0.10001, 0.1), point(0.10001, 0.10001), point(0.1, 0.10001)]))
    }

    func testSelectionRequiresExactlyFourCornersAndThenIgnoresExtraClicks() {
        var calibration = PlayingAreaCalibration()
        XCTAssertEqual(calibration.select(rectangle[0]), .ignored)
        calibration.begin()
        for index in 0..<3 { XCTAssertEqual(calibration.select(rectangle[index]), .cornerAccepted(index + 1)) }
        XCTAssertNil(calibration.area)
        XCTAssertEqual(calibration.select(rectangle[3]), .ready)
        XCTAssertFalse(calibration.isSelecting)
        XCTAssertNotNil(calibration.area)
        XCTAssertEqual(calibration.select(rectangle[0]), .ignored)
    }

    func testInvalidSelectionRetriesAndResetClearsAllGeometry() {
        var calibration = PlayingAreaCalibration()
        calibration.begin()
        for _ in 0..<3 { _ = calibration.select(rectangle[0]) }
        XCTAssertEqual(calibration.select(rectangle[0]), .invalidPolygon)
        XCTAssertTrue(calibration.isSelecting)
        XCTAssertTrue(calibration.draft.isEmpty)
        for corner in rectangle { _ = calibration.select(corner) }
        XCTAssertNotNil(calibration.area)
        calibration.reset()
        XCTAssertNil(calibration.area)
        XCTAssertTrue(calibration.draft.isEmpty)
        XCTAssertFalse(calibration.isSelecting)
    }

    func testMirroredLetterboxedClicksRecoverSamePlayingArea() {
        let projection = PreviewProjection(x: 100, y: 50, width: 800, height: 450)!
        for mirrored in [false, true] {
            var calibration = PlayingAreaCalibration()
            calibration.begin()
            for corner in perspective {
                let pixel = projection.project(corner, mirrored: mirrored)
                _ = calibration.select(projection.unproject(x: pixel.x, y: pixel.y, mirrored: mirrored)!)
            }
            let center = calibration.area!.tableCoordinates(of: point(0.5, 17.0 / 30.0))!
            XCTAssertEqual(center.x, 0.5, accuracy: 1e-8)
            XCTAssertEqual(center.y, 0.5, accuracy: 1e-8)
        }
    }
}
