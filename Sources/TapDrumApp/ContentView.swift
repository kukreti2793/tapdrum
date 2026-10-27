import SwiftUI
import TapDrumCore

@MainActor
struct ContentView: View {
    @ObservedObject var model: CameraModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("TapDrum").font(.largeTitle.bold())
                Text("Milestone 1 · Hand tracking").foregroundStyle(.secondary)
                Spacer()
                Label("Camera only · No recordings", systemImage: "lock.shield")
            }
            cameraControls
            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading) {
                    ZStack {
                        CameraPreview(session: model.session, hands: model.hands,
                                      mirrored: model.mirrorPreview, minimumConfidence: model.minimumConfidence)
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
                        Spacer()
                        Text("Overlay confidence").font(.caption)
                        Slider(value: $model.minimumConfidence, in: 0...1).frame(width: 130)
                        Text(model.minimumConfidence, format: .number.precision(.fractionLength(2))).monospacedDigit()
                    }
                    Text("Use landscape orientation. Green: estimated left hand · Orange: estimated right hand · Dashed circle: palm proxy.")
                        .font(.caption).foregroundStyle(.secondary)
                    Text("Hand pose does not prove table contact. This prototype does not detect strikes or produce sound.")
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
            Text("\(model.hands.count) hands detected")
            ForEach(Array(model.hands.enumerated()), id: \.offset) { _, hand in
                VStack(alignment: .leading) {
                    Text(hand.handedness.label).font(.callout.bold())
                    Text("\(hand.visibleJoints(minimumConfidence: model.minimumConfidence).count)/21 visible joints")
                    Text("Mean joint confidence: \(number(hand.meanJointConfidence, digits: 2))")
                }.font(.caption)
            }
            Divider()
            Text("Frame diagnostics").font(.headline)
            metric("Analyzed fps", model.diagnostics.deliveredFPS)
            Text("Received / analyzed: \(model.diagnostics.received) / \(model.diagnostics.analyzed)")
            Text("Dropped: \(model.diagnostics.dropped) · Rejected: \(model.diagnostics.rejected)")
            Text("Vision failures: \(model.diagnostics.failures)")
            metric("Vision p50 (ms)", model.diagnostics.inferenceMS.quantile(0.5))
            metric("Vision p95 (ms)", model.diagnostics.inferenceMS.quantile(0.95))
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

    private func number(_ value: Double?, digits: Int = 1) -> String {
        guard let value, value.isFinite else { return "—" }
        return value.formatted(.number.precision(.fractionLength(digits)))
    }
}
