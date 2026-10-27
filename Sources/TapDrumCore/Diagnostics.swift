import Foundation

public enum FrameFreshness {
    public static func isFresh(frameHostTime: Double, now: Double, maximumAge: Double = 0.25) -> Bool {
        guard frameHostTime.isFinite, now.isFinite, maximumAge.isFinite, maximumAge >= 0 else { return false }
        let age = now - frameHostTime
        return age >= 0 && age <= maximumAge
    }
}

/// Fixed-capacity numerical history only. No frames, audio or landmark trajectories.
public struct RollingSamples: Sendable {
    private var values: [Double] = []
    private var cursor = 0
    public let capacity: Int

    public init(capacity: Int = 240) {
        precondition(capacity > 0)
        self.capacity = capacity
    }

    public var count: Int { values.count }

    public mutating func append(_ value: Double) {
        guard value.isFinite, value >= 0 else { return }
        if values.count < capacity { values.append(value) }
        else { values[cursor] = value }
        cursor = (cursor + 1) % capacity
    }

    /// Nearest-rank quantile, including the lower middle for an even-sized p50.
    public func quantile(_ fraction: Double) -> Double? {
        guard !values.isEmpty, fraction.isFinite, (0...1).contains(fraction) else { return nil }
        let sorted = values.sorted()
        let index = max(0, Int(ceil(fraction * Double(sorted.count))) - 1)
        return sorted[index]
    }

    public var mean: Double? {
        values.isEmpty ? nil : values.reduce(0, +) / Double(values.count)
    }
}

/// A capture run has one source timeline. Reject invalid/repeated/older frames.
public struct FrameTimeline: Sendable {
    public private(set) var lastTimestamp: Double?
    public private(set) var rejected = 0

    public init() {}

    public mutating func accept(_ timestamp: Double) -> Bool {
        guard timestamp.isFinite, lastTimestamp.map({ timestamp > $0 }) ?? true else {
            rejected += 1
            return false
        }
        lastTimestamp = timestamp
        return true
    }
}

public struct FrameDiagnostics: Sendable {
    public private(set) var received = 0
    public private(set) var analyzed = 0
    public private(set) var dropped = 0
    public private(set) var failures = 0
    public private(set) var rejected = 0
    public private(set) var inferenceMS = RollingSamples()
    public private(set) var sourceAgeMS = RollingSamples()
    private var intervals = RollingSamples()
    private var previousSourceTime: Double?

    public init() {}

    public mutating func recordReceived() { received += 1 }
    public mutating func recordDrop() { dropped += 1 }
    public mutating func recordRejected() { rejected += 1 }
    public mutating func recordFailure() { failures += 1 }

    public mutating func recordAnalysis(sourceTime: Double, durationMS: Double, sourceAgeMS: Double?) {
        analyzed += 1
        inferenceMS.append(durationMS)
        if let age = sourceAgeMS { self.sourceAgeMS.append(age) }
        if sourceTime.isFinite {
            if let previous = previousSourceTime, sourceTime > previous {
                intervals.append(sourceTime - previous)
            }
            previousSourceTime = sourceTime
        }
    }

    /// Delivered/analyzed sample cadence, including gaps. Not the sensor's rated FPS.
    public var deliveredFPS: Double? {
        guard let interval = intervals.mean, interval > 0 else { return nil }
        return 1 / interval
    }
}

public struct CPUUsageSampler: Sendable {
    private var previous: (cpu: Double, host: Double)?
    public init() {}

    /// Process user+system CPU; 100% means one fully occupied logical core.
    public mutating func sample(cpuSeconds: Double, hostSeconds: Double) -> Double? {
        guard cpuSeconds.isFinite, cpuSeconds >= 0, hostSeconds.isFinite else { return nil }
        guard let old = previous else {
            previous = (cpuSeconds, hostSeconds)
            return nil
        }
        guard hostSeconds > old.host, cpuSeconds >= old.cpu else { return nil }
        previous = (cpuSeconds, hostSeconds)
        return 100 * (cpuSeconds - old.cpu) / (hostSeconds - old.host)
    }
}
