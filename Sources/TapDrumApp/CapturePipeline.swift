import AVFoundation
import Foundation
import TapDrumCore

/// Session configuration AND synchronous inference are confined to this queue.
/// AVCaptureVideoDataOutput discards late frames while the delegate is busy.
final class CapturePipeline: NSObject {
    let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "app.tapdrum.capture", qos: .userInitiated)
    private let output = AVCaptureVideoDataOutput()
    private var frameDelegate: CaptureFrameDelegate?
    private let tracker: HandTracker
    private let onSnapshot: (PipelineSnapshot) -> Void
    private let onDevices: ([CameraDescriptor]) -> Void
    private var observers: [NSObjectProtocol] = []
    private var devices: [String: AVCaptureDevice] = [:]
    private var generation = 0
    private var activeDeviceID: String?
    private var phase: CapturePhase = .stopped
    private var timeline = FrameTimeline()
    private var diagnostics = FrameDiagnostics()
    private var hands: [HandObservation] = []
    private var lastFrameHostTime: Double?
    private var lastPublishTime = -Double.infinity
    private var trackingError: String?

    init(tracker: HandTracker = VisionHandTracker(),
         onSnapshot: @escaping (PipelineSnapshot) -> Void,
         onDevices: @escaping ([CameraDescriptor]) -> Void) {
        self.tracker = tracker
        self.onSnapshot = onSnapshot
        self.onDevices = onDevices
        super.init()
        observeNotifications()
    }

    deinit { observers.forEach { NotificationCenter.default.removeObserver($0) } }

    func refreshDevices() { queue.async { self.discoverDevices() } }

    func start(deviceID: String, mode: CameraMode, generation: Int) {
        queue.async {
            self.generation = generation
            self.stopSession()
            self.timeline = FrameTimeline()
            self.diagnostics = FrameDiagnostics()
            self.lastFrameHostTime = nil
            self.trackingError = nil
            self.lastPublishTime = -.infinity
            self.phase = .starting
            self.publish(force: true)
            do {
                guard let device = self.devices[deviceID], device.isConnected else {
                    throw CaptureError.message("The selected camera is unavailable. Refresh the camera list.")
                }
                try self.configure(device: device, mode: mode)
                self.activeDeviceID = deviceID
                self.session.startRunning()
                guard self.session.isRunning else { throw CaptureError.message("The camera did not start. Check camera permissions and other apps using it.") }
                self.phase = .running
            } catch {
                self.stopSession()
                self.phase = .failed(error.localizedDescription)
            }
            self.publish(force: true)
        }
    }

    func stop(generation: Int, completion: (@MainActor @Sendable () -> Void)? = nil) {
        queue.async {
            self.generation = generation
            self.stopSession()
            self.phase = .stopped
            self.publish(force: true)
            if let completion { DispatchQueue.main.async(execute: completion) }
        }
    }

    private func stopSession() {
        output.setSampleBufferDelegate(nil, queue: nil)
        frameDelegate = nil
        if session.isRunning { session.stopRunning() }
        activeDeviceID = nil
        hands = []
        lastFrameHostTime = nil
        trackingError = nil
    }

    private func configure(device: AVCaptureDevice, mode: CameraMode) throws {
        guard device.formats.indices.contains(mode.formatIndex) else {
            throw CaptureError.message("The selected format changed. Refresh cameras and choose a supported mode.")
        }
        let format = device.formats[mode.formatIndex]
        let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
        guard dimensions.width == mode.width, dimensions.height == mode.height,
              let range = format.videoSupportedFrameRateRanges.first(where: {
                  mode.framesPerSecond >= $0.minFrameRate && mode.framesPerSecond <= $0.maxFrameRate
              }) else { throw CaptureError.message("This camera does not support the selected resolution/frame rate.") }

        session.beginConfiguration()
        defer { session.commitConfiguration() }
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }
        // On macOS configure activeFormat/frame durations directly. The
        // inputPriority session preset is unavailable in the macOS SDK.
        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else { throw CaptureError.message("The camera input could not be added.") }
        session.addInput(input)

        try device.lockForConfiguration()
        device.activeFormat = format
        let requested = CMTime(seconds: 1 / mode.framesPerSecond, preferredTimescale: 1_000_000_000)
        let duration = CMTimeMaximum(range.minFrameDuration, CMTimeMinimum(range.maxFrameDuration, requested))
        device.activeVideoMinFrameDuration = duration
        device.activeVideoMaxFrameDuration = duration
        device.unlockForConfiguration()

        guard session.canAddOutput(output) else { throw CaptureError.message("The camera's frame-processing output is unavailable.") }
        session.addOutput(output)
        // Prefer NV12; BGRA is a compatibility fallback whose overhead needs profiling.
        let candidates: [OSType] = [kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                   kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                   kCVPixelFormatType_32BGRA]
        guard let pixelFormat = candidates.first(where: { output.availableVideoPixelFormatTypes.contains($0) }) else {
            throw CaptureError.message("No supported Vision pixel format is available for this camera mode.")
        }
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: pixelFormat]
        output.alwaysDiscardsLateVideoFrames = true
        let receiver = CaptureFrameDelegate(owner: self, generation: generation)
        frameDelegate = receiver
        output.setSampleBufferDelegate(receiver, queue: queue)
        if let connection = output.connection(with: .video) {
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = false
            }
            if connection.isVideoRotationAngleSupported(0) { connection.videoRotationAngle = 0 }
        }
    }

    private func discoverDevices() {
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external, .continuityCamera],
            mediaType: .video, position: .unspecified
        )
        devices = Dictionary(discovery.devices.map { ($0.uniqueID, $0) }, uniquingKeysWith: { first, _ in first })
        let descriptors = devices.values.map { device -> CameraDescriptor in
            var modes: [CameraMode] = []
            var seenModes: Set<String> = []
            for (index, format) in device.formats.enumerated() {
                let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                guard dimensions.width > 0, dimensions.height > 0 else { continue }
                let ranges = format.videoSupportedFrameRateRanges
                let candidates = Set([24.0, 25, 30, 50, 60] + ranges.map(\.maxFrameRate) + ranges.map(\.minFrameRate))
                for fps in candidates.sorted() where fps.isFinite && fps > 0 {
                    guard ranges.contains(where: { fps >= $0.minFrameRate && fps <= $0.maxFrameRate }) else { continue }
                    // Show each supported size/rate once, using its first advertised format.
                    guard seenModes.insert("\(dimensions.width)-\(dimensions.height)-\(fps)").inserted else { continue }
                    modes.append(CameraMode(formatIndex: index, width: dimensions.width, height: dimensions.height,
                                            framesPerSecond: fps))
                }
            }
            return CameraDescriptor(id: device.uniqueID, name: device.localizedName,
                                    isContinuityCamera: device.isContinuityCamera, modes: modes)
        }.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        onDevices(descriptors)
        if let activeDeviceID, devices[activeDeviceID] == nil {
            stopSession()
            phase = .failed("Camera disconnected. Reconnect it, refresh cameras, and press Start.")
            publish(force: true)
        }
    }

    fileprivate func process(_ sampleBuffer: CMSampleBuffer, generation: Int) {
        guard phase.isRunning, generation == self.generation else { return }
        autoreleasepool {
            diagnostics.recordReceived()
            let arrival = HostTime.seconds
            let pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            guard timeline.accept(CMTimeGetSeconds(pts)) else {
                diagnostics.recordRejected()
                return
            }
            guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                diagnostics.recordFailure()
                hands = []
                trackingError = "The camera delivered a sample without an image buffer."
                publish(force: false)
                return
            }
            var ageMS: Double?
            if let sourceClock = session.synchronizationClock {
                let hostPTS = CMSyncConvertTime(pts, from: sourceClock, to: CMClockGetHostTimeClock())
                let age = (arrival - CMTimeGetSeconds(hostPTS)) * 1000
                if age.isFinite, age >= 0 { ageMS = age }
            }
            let start = HostTime.seconds
            do {
                hands = try tracker.analyze(buffer)
                diagnostics.recordAnalysis(sourceTime: CMTimeGetSeconds(pts), durationMS: (HostTime.seconds - start) * 1000,
                                           sourceAgeMS: ageMS)
                trackingError = nil
            } catch {
                diagnostics.recordFailure()
                hands = []
                trackingError = "Vision could not analyze the frame: \(error.localizedDescription)"
            }
            lastFrameHostTime = arrival
            publish(force: false)
        }
    }

    fileprivate func recordDrop(generation: Int) {
        if phase.isRunning, generation == self.generation { diagnostics.recordDrop() }
    }

    private func publish(force: Bool) {
        let now = HostTime.seconds
        guard force || now - lastPublishTime >= 0.1 else { return }
        lastPublishTime = now
        onSnapshot(PipelineSnapshot(generation: generation, phase: phase, hands: hands, diagnostics: diagnostics,
                                    lastFrameHostTime: lastFrameHostTime, trackingError: trackingError))
    }

    private func observeNotifications() {
        let center = NotificationCenter.default
        for name: Notification.Name in [.AVCaptureDeviceWasConnected, .AVCaptureDeviceWasDisconnected] {
            observers.append(center.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
                self?.refreshDevices()
            })
        }
        observers.append(center.addObserver(forName: AVCaptureSession.wasInterruptedNotification, object: session, queue: nil) { [weak self] _ in
            self?.queue.async { [weak self] in
                guard let self else { return }
                self.stopSession()
                self.phase = .failed("Camera interrupted. Check the phone/camera connection, then press Start again.")
                self.publish(force: true)
            }
        })
        observers.append(center.addObserver(forName: AVCaptureSession.runtimeErrorNotification, object: session, queue: nil) { [weak self] notification in
            let message = (notification.userInfo?[AVCaptureSessionErrorKey] as? NSError)?.localizedDescription ?? "Unknown capture error"
            self?.queue.async { [weak self] in
                guard let self else { return }
                self.stopSession()
                self.phase = .failed("Camera error: \(message). Press Start to retry after resolving it.")
                self.publish(force: true)
            }
        })
    }
}

/// Old queued callbacks retain their run token and cannot update a later run.
private final class CaptureFrameDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private weak var owner: CapturePipeline?
    private let generation: Int

    init(owner: CapturePipeline, generation: Int) {
        self.owner = owner
        self.generation = generation
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        owner?.process(sampleBuffer, generation: generation)
    }

    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        owner?.recordDrop(generation: generation)
    }
}

private enum CaptureError: LocalizedError {
    case message(String)
    var errorDescription: String? { if case .message(let value) = self { return value }; return nil }
}
