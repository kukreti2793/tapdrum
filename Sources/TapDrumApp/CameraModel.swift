import AppKit
import AVFoundation
import Combine
import TapDrumCore

@MainActor
final class CameraModel: ObservableObject {
    @Published private(set) var cameras: [CameraDescriptor] = []
    @Published var selectedCameraID = "" {
        didSet {
            if selectedCameraID != oldValue { selectedModeID = selectedCamera?.defaultMode?.id ?? "" }
        }
    }
    @Published var selectedModeID = ""
    @Published var mirrorPreview = false
    @Published var showFingerLabels = true
    @Published var minimumConfidence = 0.72 {
        didSet {
            if minimumConfidence.isFinite, (0...1).contains(minimumConfidence) {
                UserDefaults.standard.set(minimumConfidence, forKey: "overlayMinimumConfidence")
            }
        }
    }
    @Published private(set) var phase: CapturePhase = .stopped
    @Published private(set) var hands: [HandObservation] = []
    @Published private(set) var diagnostics = FrameDiagnostics()
    @Published private(set) var resources = ResourceReadout()
    @Published private(set) var memoryPressure = "Not observed"
    @Published private(set) var trackingError: String?
    @Published private(set) var framesAreStale = false

    private var generation = 0
    private var lastFrameHostTime: Double?
    private var startedHostTime: Double?
    private var resourceSampler = ResourceSampler()
    private var lastResourceTime = -Double.infinity
    private var timer: Timer?
    private var pressureSource: DispatchSourceMemoryPressure?
    private lazy var pipeline = CapturePipeline(
        onSnapshot: { [weak self] snapshot in
            DispatchQueue.main.async { self?.apply(snapshot) }
        },
        onDevices: { [weak self] devices in
            DispatchQueue.main.async { self?.updateDevices(devices) }
        }
    )

    var session: AVCaptureSession { pipeline.session }
    var selectedCamera: CameraDescriptor? { cameras.first { $0.id == selectedCameraID } }
    var selectedMode: CameraMode? { selectedCamera?.modes.first { $0.id == selectedModeID } }
    var canConfigure: Bool { !phase.isRunning && !phase.isBusy }

    init() {
        if UserDefaults.standard.object(forKey: "overlayMinimumConfidence") != nil {
            let saved = UserDefaults.standard.double(forKey: "overlayMinimumConfidence")
            if saved.isFinite, (0...1).contains(saved) { minimumConfidence = saved }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        let source = DispatchSource.makeMemoryPressureSource(eventMask: [.normal, .warning, .critical], queue: .main)
        pressureSource = source
        source.setEventHandler { [weak self] in
            Task { @MainActor in
                guard let self, let event = self.pressureSource?.data else { return }
                self.memoryPressure = event.contains(.critical) ? "Critical" : event.contains(.warning) ? "Warning" : "Normal"
            }
        }
        source.resume()
    }

    deinit {
        timer?.invalidate()
        pressureSource?.cancel()
    }

    func refreshDevices() { pipeline.refreshDevices() }

    func start() {
        guard canConfigure, let mode = selectedMode else { return }
        generation += 1
        let token = generation
        let deviceID = selectedCameraID
        hands = []
        diagnostics = FrameDiagnostics()
        trackingError = nil
        framesAreStale = false
        lastFrameHostTime = nil
        startedHostTime = HostTime.seconds
        phase = .requestingPermission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            phase = .starting
            pipeline.start(deviceID: deviceID, mode: mode, generation: token)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                DispatchQueue.main.async {
                    guard let self, self.generation == token else { return }
                    if allowed {
                        self.phase = .starting
                        self.pipeline.start(deviceID: deviceID, mode: mode, generation: token)
                    } else { self.showPermissionError() }
                }
            }
        case .denied, .restricted: showPermissionError()
        @unknown default: phase = .failed("Camera permission status is unknown. Check macOS Privacy & Security settings.")
        }
    }

    func stop(completion: (@MainActor @Sendable () -> Void)? = nil) {
        generation += 1 // Ignore queued observations and permission replies from the old run.
        hands = []
        lastFrameHostTime = nil
        startedHostTime = nil
        framesAreStale = false
        phase = .stopping
        pipeline.stop(generation: generation, completion: completion)
    }

    func openCameraSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera") {
            NSWorkspace.shared.open(url)
        }
    }

    private func showPermissionError() {
        phase = .failed("Camera access is unavailable. Enable TapDrum in System Settings → Privacy & Security → Camera, then try Start again.")
    }

    private func updateDevices(_ devices: [CameraDescriptor]) {
        cameras = devices
        if !devices.contains(where: { $0.id == selectedCameraID }) {
            selectedCameraID = devices.first(where: { !$0.isContinuityCamera })?.id ?? devices.first?.id ?? ""
        }
        if selectedMode == nil { selectedModeID = selectedCamera?.defaultMode?.id ?? "" }
    }

    private func apply(_ snapshot: PipelineSnapshot) {
        guard snapshot.generation == generation else { return }
        phase = snapshot.phase
        diagnostics = snapshot.diagnostics
        lastFrameHostTime = snapshot.lastFrameHostTime
        trackingError = snapshot.trackingError
        framesAreStale = phase.isRunning && (snapshot.lastFrameHostTime.map {
            !FrameFreshness.isFresh(frameHostTime: $0, now: HostTime.seconds)
        } ?? false)
        hands = phase.isRunning && !framesAreStale ? snapshot.hands : []
    }

    private func tick() {
        let now = HostTime.seconds
        if phase.isRunning, let last = lastFrameHostTime ?? startedHostTime,
           !FrameFreshness.isFresh(frameHostTime: last, now: now) {
            hands = []
            framesAreStale = true
        }
        if now - lastResourceTime >= 1 {
            resources = resourceSampler.sample()
            lastResourceTime = now
        }
    }
}
