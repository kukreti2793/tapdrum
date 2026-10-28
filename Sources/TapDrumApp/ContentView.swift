import SwiftUI
import TapDrumCore

@MainActor
struct ContentView: View {
    @ObservedObject var model: CameraModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("TapDrum").font(.largeTitle.bold())
                Text("Strike experiment").foregroundStyle(.secondary)
                Spacer()
                Label("Camera only · No recordings", systemImage: "lock.shield")
            }
            cameraControls
            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading) {
                    ZStack {
                        CameraPreview(session: model.session, hands: model.hands,
                                      mirrored: model.mirrorPreview, minimumConfidence: model.minimumConfidence,
                                      showFingerLabels: model.showFingerLabels, playingArea: model.playingArea,
                                      onCalibrationPoint: model.selectPlayingAreaPoint)
                        if !model.phase.isRunning || model.framesAreStale {
                            Text(model.framesAreStale ? "No recent frames · landmarks cleared" : "Press Start camera to begin")
                                .padding().background(.black.opacity(0.8)).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .aspectRatio(16.0 / 9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    Text(model.phase.message).font(.callout).textSelection(.enabled)
                    if let error = model.trackingError { Text(error).foregroundStyle(.red).textSelection(.enabled) }
                    if model.cameras.isEmpty {
                        Text("No cameras found. Connect your camera, check Continuity Camera setup, then refresh.")
                    }
                    HStack {
                        Toggle("Mirror preview", isOn: $model.mirrorPreview).toggleStyle(.checkbox)
                        Toggle("Finger names", isOn: $model.showFingerLabels).toggleStyle(.checkbox)
                        Spacer()
                        Text("Overlay confidence").font(.caption)
                        Slider(value: $model.minimumConfidence, in: 0...1).frame(width: 130)
                        Text(model.minimumConfidence, format: .number.precision(.fractionLength(2))).monospacedDigit()
                    }
                    Text("Use landscape orientation. Green: estimated left hand · Orange: estimated right hand · Dashed circle: palm proxy.")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("Experimental motion events do not prove table contact. Calibrate before testing; MIDI output is a later milestone.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                ScrollView { diagnostics }.frame(width: 280)
            }
            Spacer(minLength: 0)
        }
        .padding(24)
    }

    private var cameraControls: some View {
        HStack {
            Picker("Camera", selection: $model.selectedCameraID) {
                if model.cameras.isEmpty { Text("No cameras").tag("") }
                ForEach(model.cameras) { camera in
                    Text(camera.name + (camera.isContinuityCamera ? " · iPhone" : "")).tag(camera.id)
                }
            }
            .frame(maxWidth: 330).disabled(!model.canConfigure)
            Picker("Mode", selection: $model.selectedModeID) {
                if model.selectedCamera?.modes.isEmpty ?? true { Text("No supported modes").tag("") }
                ForEach(model.selectedCamera?.modes ?? []) { mode in Text(mode.label).tag(mode.id) }
            }
            .disabled(!model.canConfigure)
            Button("Refresh", action: model.refreshDevices).disabled(!model.canConfigure)
            if model.phase.isRunning || model.phase.isBusy {
                Button("Stop", action: { model.stop() })
                    .disabled(model.phase == .stopping)
            } else {
                Button("Start camera", action: model.start).buttonStyle(.borderedProminent)
                    .disabled(model.selectedMode == nil)
            }
            Button { model.openCameraSettings() } label: { Image(systemName: "gearshape") }
                .help("Open macOS camera privacy settings")
        }
    }

    private var diagnostics: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tracking").font(.headline)
            let visibleHands = model.hands.filter { !$0.visibleJoints(minimumConfidence: model.minimumConfidence).isEmpty }.count
            Text("\(model.hands.count) pose estimates · \(visibleHands) with visible joints")
            ForEach(Array(model.hands.enumerated()), id: \.offset) { _, hand in
                VStack(alignment: .leading) {
                    Text(hand.handedness.label).font(.callout.bold())
                    Text("\(hand.visibleJoints(minimumConfidence: model.minimumConfidence).count)/21 visible joints")
                    Text("Mean joint confidence: \(number(hand.meanJointConfidence, digits: 2))")
                }.font(.caption)
            }
            Divider()
            playingAreaControls
            Divider()
            strikeControls
            Divider()
            Text("Frame diagnostics").font(.headline)
            metric("Analyzed fps", model.diagnostics.deliveredFPS)
            Text("Received / analyzed: \(model.diagnostics.received) / \(model.diagnostics.analyzed)")
            Text("Dropped: \(model.diagnostics.dropped) · Rejected: \(model.diagnostics.rejected)")
            Text("Vision failures: \(model.diagnostics.failures)")
            metric("Vision p50 (ms)", model.diagnostics.inferenceMS.quantile(0.5))
            metric("Vision p95 (ms)", model.diagnostics.inferenceMS.quantile(0.95))
            metric("Recognition p50 (ms)", model.recognitionMS.quantile(0.5))
            metric("Recognition p95 (ms)", model.recognitionMS.quantile(0.95))
            metric("PTS → callback p50 (ms)", model.diagnostics.sourceAgeMS.quantile(0.5))
            metric("PTS → callback p95 (ms)", model.diagnostics.sourceAgeMS.quantile(0.95))
            Text("Rolling 240 samples; nearest-rank quantiles. Frame PTS is clock-converted when available. These are not contact-to-sound measurements.")
                .font(.caption2).foregroundStyle(.secondary)
            Divider()
            Text("App resources").font(.headline)
            metric("CPU (%)", model.resources.cpuPercent)
            metric("Physical footprint (MiB)", model.resources.footprintMiB)
            Text("Thermal state: \(model.resources.thermalState)")
            Text("Memory pressure event: \(model.memoryPressure)")
            Text("CPU: one occupied core = 100%. ‘—’ means unavailable; pressure is the latest observed system event.")
                .font(.caption2).foregroundStyle(.secondary)
        }
        .font(.caption)
        .padding(16)
        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12))
    }

    private func metric(_ label: String, _ value: Double?) -> some View {
        HStack { Text(label); Spacer(); Text(number(value)).monospacedDigit() }
    }

    private var playingAreaControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Playing area").font(.headline)
            HStack {
                Button(model.playingArea.isSelecting ? "Start over" : "Set area", action: model.beginPlayingArea)
                    .disabled(!model.phase.isRunning || model.framesAreStale)
                Button("Reset", action: model.resetPlayingArea)
                    .disabled(model.playingArea.area == nil && !model.playingArea.isSelecting)
            }
            Text(model.calibrationMessage).font(.caption)
            if model.playingArea.area != nil {
                Text("\(model.projectedFingertipCount) fingertip estimates project inside the area.").font(.caption)
            }
            Text("Image positions only; contact and height are not measured. Reset after any camera movement. Area is cleared on stop, mode changes or video stalls.")
                .font(.caption2).foregroundStyle(.secondary)
        }
    }

    private func number(_ value: Double?, digits: Int = 1) -> String {
        guard let value, value.isFinite else { return "—" }
        return value.formatted(.number.precision(.fractionLength(digits)))
    }

    private var strikeControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Strike experiment").font(.headline)
            Picker("Hand", selection: $model.selectedStrikeHand) {
                Text("Left").tag(Handedness.left)
                Text("Right").tag(Handedness.right)
            }.disabled(model.strikes.collecting)
            Picker("Contact", selection: $model.selectedStrikeContact) {
                ForEach(DrumContact.allCases, id: \.self) { Text($0.label).tag($0) }
            }.disabled(model.strikes.collecting)
            Text("Hold the contact on the table → Learn rest. Lift it clearly, keeping the wrist still → Learn lifted. Hold each pose for 0.5 s.")
            HStack {
                Button("Learn rest") { model.learnStrikeReference(lifted: false) }
                Button("Learn lifted") { model.learnStrikeReference(lifted: true) }
                    .disabled(!model.strikes.restKeys.contains(model.selectedStrikeKey))
            }.disabled(model.playingArea.area == nil || model.strikes.collecting || model.framesAreStale)
            Text(model.strikes.message).textSelection(.enabled)
            Text("\(model.strikes.readyKeys.count)/12 contacts calibrated · \(model.strikes.processedFrames) analyzed frames")
            HStack {
                Button(model.strikes.enabled ? "Pause detection" : "Enable detection", action: model.toggleStrikeDetection)
                    .disabled(model.strikes.readyKeys.isEmpty || model.strikes.collecting || model.framesAreStale)
                Button("Clear counts", action: model.clearStrikeEvents)
            }
            Text("Selected: \(model.strikes.states[model.selectedStrikeKey] ?? "Not armed")")
            metric("Rest 0 → lifted 1", model.strikes.levels[model.selectedStrikeKey])
            Text("Selected events: \(model.strikes.counts[model.selectedStrikeKey, default: 0]) · Total: \(model.strikes.counts.values.reduce(0, +))")
                .font(.callout.bold())
            ForEach(model.strikes.recentEvents.suffix(5).reversed()) { event in
                Text("#\(event.id) \(event.key.label) · source \(number(event.evidence.candidateSourceTime, digits: 3)) s · confirmed host \(number(event.recognizedHostTime, digits: 3)) s · reversal wait \(number(event.evidence.evidenceDelayMS)) ms")
                    .font(.caption2).textSelection(.enabled)
            }
            Text("Events are camera motion estimates. Near-table hovering can resemble a strike. Palm proxy: lift/lower the whole palm; it is not a measured palm-base contact. Reset area/relearn after camera or hand-position changes. No sound, MIDI, microphone or recording in this experiment.")
                .font(.caption2).foregroundStyle(.secondary)
        }
    }
}
