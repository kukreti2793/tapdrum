import AppKit
import AVFoundation
import SwiftUI
import TapDrumCore

@MainActor
struct CameraPreview: NSViewRepresentable {
    let session: AVCaptureSession
    let hands: [HandObservation]
    let mirrored: Bool
    let minimumConfidence: Double
    let showFingerLabels: Bool

    func makeNSView(context: Context) -> PreviewView { PreviewView(session: session) }

    func updateNSView(_ view: PreviewView, context: Context) {
        view.hands = hands
        view.mirrored = mirrored
        view.minimumConfidence = minimumConfidence
        view.showFingerLabels = showFingerLabels
        view.needsLayout = true
    }
}

final class PreviewView: NSView {
    private let previewLayer: AVCaptureVideoPreviewLayer
    private let overlay = CALayer()
    var hands: [HandObservation] = []
    var mirrored = false
    var minimumConfidence = 0.3
    var showFingerLabels = true
    private var projection: PreviewProjection?
    private var effectiveMirroring = false

    // The overlay paths use lower-left coordinates, matching Vision's origin.
    override var isFlipped: Bool { false }

    init(session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init(frame: .zero)
        wantsLayer = true
        layer = CALayer()
        layer?.backgroundColor = NSColor.black.cgColor
        previewLayer.videoGravity = .resizeAspect
        layer?.addSublayer(previewLayer)
        layer?.addSublayer(overlay)
    }

    required init?(coder: NSCoder) { return nil }

    override func layout() {
        super.layout()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        previewLayer.frame = bounds
        overlay.frame = bounds
        if let connection = previewLayer.connection {
            if connection.isVideoRotationAngleSupported(0) { connection.videoRotationAngle = 0 }
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = mirrored
            }
            effectiveMirroring = connection.isVideoMirroringSupported && connection.isVideoMirrored
        }
        let imageRect = previewLayer.layerRectConverted(fromMetadataOutputRect: CGRect(x: 0, y: 0, width: 1, height: 1))
        projection = PreviewProjection(x: imageRect.minX, y: imageRect.minY,
                                       width: imageRect.width, height: imageRect.height)
        drawOverlay()
        CATransaction.commit()
    }

    private func drawOverlay() {
        overlay.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard let projection else { return }
        func layerPoint(_ point: NormalizedPoint) -> CGPoint {
            let p = projection.project(point, mirrored: effectiveMirroring)
            return CGPoint(x: p.x, y: p.y)
        }
        for hand in hands {
            let color: NSColor = hand.handedness == .left ? .systemGreen : hand.handedness == .right ? .systemOrange : .white
            let joints = hand.visibleJoints(minimumConfidence: minimumConfidence)
            let path = CGMutablePath()
            for chain in HandJoint.fingerChains {
                for index in 1..<chain.count {
                    guard let a = joints[chain[index - 1]], let b = joints[chain[index]] else { continue }
                    path.move(to: layerPoint(a.point))
                    path.addLine(to: layerPoint(b.point))
                }
            }
            for landmark in joints.values {
                let p = layerPoint(landmark.point)
                path.addEllipse(in: CGRect(x: p.x - 3, y: p.y - 3, width: 6, height: 6))
            }
            let shape = CAShapeLayer()
            shape.path = path
            shape.strokeColor = color.cgColor
            shape.fillColor = NSColor.clear.cgColor
            shape.lineWidth = 2
            overlay.addSublayer(shape)
            if let palm = hand.palmProxy(minimumConfidence: minimumConfidence) {
                let p = layerPoint(palm)
                let marker = CAShapeLayer()
                marker.path = CGPath(ellipseIn: CGRect(x: p.x - 9, y: p.y - 9, width: 18, height: 18), transform: nil)
                marker.strokeColor = color.cgColor
                marker.fillColor = NSColor.clear.cgColor
                marker.lineDashPattern = [3, 3]
                overlay.addSublayer(marker)
            }
            if let wrist = joints[.wrist] {
                let p = layerPoint(wrist.point)
                addLabel("\(hand.handedness.label) · \(joints.count)/21 joints", at: p, color: color)
            }
            let tips: [(HandJoint, String)] = [(.thumbTip, "Thumb"), (.indexTip, "Index"),
                                               (.middleTip, "Middle"), (.ringTip, "Ring"), (.littleTip, "Little")]
            for (joint, name) in tips where showFingerLabels {
                if let landmark = joints[joint] {
                    addLabel(name, at: layerPoint(landmark.point), color: color, width: 70)
                }
            }
        }
        if mirrored, let connection = previewLayer.connection, !connection.isVideoMirroringSupported {
            addLabel("Mirroring unavailable for this camera", at: CGPoint(x: 12, y: 24), color: .systemYellow)
        }
    }

    private func addLabel(_ text: String, at point: CGPoint, color: NSColor, width: CGFloat = 250) {
        let label = CATextLayer()
        label.string = text
        label.fontSize = 12
        label.foregroundColor = color.cgColor
        label.backgroundColor = NSColor.black.withAlphaComponent(0.65).cgColor
        label.contentsScale = window?.backingScaleFactor ?? 2
        label.frame = CGRect(x: min(max(0, point.x + 8), max(0, bounds.width - width)),
                             y: min(max(0, point.y + 8), max(0, bounds.height - 22)), width: width, height: 20)
        overlay.addSublayer(label)
    }
}
