import XCTest
@testable import TapDrumCore

final class DiagnosticsTests: XCTestCase {
    func testOldFutureAndInvalidFramesCannotLeaveAVisibleHandOverlay() {
        XCTAssertTrue(FrameFreshness.isFresh(frameHostTime: 10, now: 10.25))
        XCTAssertFalse(FrameFreshness.isFresh(frameHostTime: 10, now: 10.251))
        XCTAssertFalse(FrameFreshness.isFresh(frameHostTime: 11, now: 10))
        XCTAssertFalse(FrameFreshness.isFresh(frameHostTime: .nan, now: 10))
        XCTAssertFalse(FrameFreshness.isFresh(frameHostTime: 10, now: 10, maximumAge: -1))
    }

    func testRollingQuantilesEvictOldSamplesAndRejectInvalidMeasurements() {
        var samples = RollingSamples(capacity: 3)
        XCTAssertNil(samples.quantile(0.5))
        [100.0, 1, 2, 3].forEach { samples.append($0) }
        samples.append(.nan)
        samples.append(-1)
        XCTAssertEqual(samples.count, 3)
        XCTAssertEqual(samples.quantile(0), 1)
        XCTAssertEqual(samples.quantile(0.5), 2)
        XCTAssertEqual(samples.quantile(0.95), 3)
        XCTAssertEqual(samples.mean, 2)
        XCTAssertNil(samples.quantile(1.1))
    }

    func testTimelineRejectsOldAndDuplicateFramesWithoutMovingBaseline() {
        var timeline = FrameTimeline()
        XCTAssertTrue(timeline.accept(10))
        XCTAssertFalse(timeline.accept(10))
        XCTAssertFalse(timeline.accept(9))
        XCTAssertFalse(timeline.accept(.nan))
        XCTAssertTrue(timeline.accept(10.1))
        XCTAssertEqual(timeline.rejected, 3)
        XCTAssertEqual(timeline.lastTimestamp, 10.1)
    }

    func testDeliveredFPSIncludesDroppedFrameGapsAndDoesNotInventAge() {
        var stats = FrameDiagnostics()
        stats.recordReceived()
        stats.recordAnalysis(sourceTime: 0, durationMS: 5, sourceAgeMS: nil)
        XCTAssertNil(stats.deliveredFPS)
        XCTAssertNil(stats.sourceAgeMS.quantile(0.5))
        stats.recordDrop()
        stats.recordReceived()
        stats.recordAnalysis(sourceTime: 2.0 / 30.0, durationMS: 7, sourceAgeMS: 12)
        XCTAssertEqual(stats.deliveredFPS!, 15, accuracy: 1e-9)
        XCTAssertEqual(stats.dropped, 1)
        XCTAssertEqual(stats.analyzed, 2)
        XCTAssertEqual(stats.sourceAgeMS.quantile(0.5), 12)
        stats = FrameDiagnostics()
        XCTAssertEqual(stats.analyzed, 0)
        XCTAssertNil(stats.deliveredFPS)
    }

    func testCPUDeltaUsesOneCoreConventionAndIgnoresOutOfOrderReadings() {
        var cpu = CPUUsageSampler()
        XCTAssertNil(cpu.sample(cpuSeconds: 10, hostSeconds: 1))
        XCTAssertEqual(cpu.sample(cpuSeconds: 12, hostSeconds: 2), 200)
        XCTAssertNil(cpu.sample(cpuSeconds: 13, hostSeconds: 2))
        XCTAssertNil(cpu.sample(cpuSeconds: 11, hostSeconds: 3))
        XCTAssertEqual(cpu.sample(cpuSeconds: 12.5, hostSeconds: 3), 50)
    }
}
