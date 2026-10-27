import CoreVideo
import ImageIO
import TapDrumCore
import Vision

/// Frame-scoped observations only. No persistent identity, recording or contact claims.
protocol HandTracker {
    func analyze(_ pixelBuffer: CVPixelBuffer) throws -> [HandObservation]
}

final class VisionHandTracker: HandTracker {
    private let request: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        return request
    }()

    // Explicit mapping avoids deriving anatomical identity from array ordering.
    private static let jointMap: [(HandJoint, VNHumanHandPoseObservation.JointName)] = [
        (.wrist, .wrist),
        (.thumbCMC, .thumbCMC), (.thumbMP, .thumbMP), (.thumbIP, .thumbIP), (.thumbTip, .thumbTip),
        (.indexMCP, .indexMCP), (.indexPIP, .indexPIP), (.indexDIP, .indexDIP), (.indexTip, .indexTip),
        (.middleMCP, .middleMCP), (.middlePIP, .middlePIP), (.middleDIP, .middleDIP), (.middleTip, .middleTip),
        (.ringMCP, .ringMCP), (.ringPIP, .ringPIP), (.ringDIP, .ringDIP), (.ringTip, .ringTip),
        (.littleMCP, .littleMCP), (.littlePIP, .littlePIP), (.littleDIP, .littleDIP), (.littleTip, .littleTip)
    ]

    func analyze(_ pixelBuffer: CVPixelBuffer) throws -> [HandObservation] {
        // Capture and preview connections use zero rotation; M1 requires landscape.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        try handler.perform([request])
        return try (request.results ?? []).map { observation in
            let points = try observation.recognizedPoints(.all)
            var joints: [HandJoint: HandLandmark] = [:]
            for (joint, visionJoint) in Self.jointMap {
                guard let value = points[visionJoint],
                      let point = NormalizedPoint(x: value.location.x, y: value.location.y),
                      let landmark = HandLandmark(point: point, confidence: Double(value.confidence)) else { continue }
                joints[joint] = landmark
            }
            let handedness: Handedness
            switch observation.chirality {
            case .left: handedness = .left
            case .right: handedness = .right
            case .unknown: handedness = .unknown
            @unknown default: handedness = .unknown
            }
            return HandObservation(handedness: handedness, joints: joints)
        }
    }
}
