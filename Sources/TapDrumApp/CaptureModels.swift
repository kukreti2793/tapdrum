import AVFoundation
import TapDrumCore

enum CapturePhase: Equatable, Sendable {
    case stopped, requestingPermission, starting, stopping, running
    case failed(String)

    var message: String {
        switch self {
        case .stopped: return "Camera stopped"
        case .requestingPermission: return "Waiting for camera permission…"
        case .starting: return "Starting camera…"
        case .stopping: return "Stopping camera…"
        case .running: return "Live · local processing"
        case .failed(let message): return message
        }
    }

    var isRunning: Bool { self == .running }
    var isBusy: Bool { self == .starting || self == .stopping || self == .requestingPermission }
}

struct CameraMode: Identifiable, Hashable, Sendable {
    let formatIndex: Int
    let width: Int32
    let height: Int32
    let framesPerSecond: Double
    var id: String { "\(formatIndex)-\(framesPerSecond)" }
    var label: String {
        "\(width) × \(height) · \(framesPerSecond.formatted(.number.precision(.fractionLength(0...2)))) fps"
    }
}

struct CameraDescriptor: Identifiable, Sendable {
    let id: String
    let name: String
    let isContinuityCamera: Bool
    let modes: [CameraMode]

    var defaultMode: CameraMode? {
        // Prefer a modest analysis workload; higher FPS is an explicit experiment.
        modes.min {
            score($0) < score($1)
        }
    }

    private func score(_ mode: CameraMode) -> Double {
        abs(Double(mode.width) - 1280) + abs(Double(mode.height) - 720)
            + 100 * abs(mode.framesPerSecond - 30)
    }
}

struct PipelineSnapshot: Sendable {
    let generation: Int
    let phase: CapturePhase
    let hands: [HandObservation]
    let diagnostics: FrameDiagnostics
    let lastFrameHostTime: Double?
    let trackingError: String?
}

enum HostTime {
    static var seconds: Double { CMTimeGetSeconds(CMClockGetTime(CMClockGetHostTimeClock())) }
}
