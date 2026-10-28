/// Four image points ordered around a convex tabletop region. The homography
/// rectifies projected on-plane positions only; it cannot measure height/contact.
public struct PlayingArea: Sendable {
    public let corners: [NormalizedPoint]
    private let forward: ProjectiveMap
    private let backward: ProjectiveMap

    public init?(corners: [NormalizedPoint]) {
        guard corners.count == 4 else { return nil }
        var turns: [Double] = []
        var twiceArea = 0.0
        for index in 0..<4 {
            let a = corners[index], b = corners[(index + 1) % 4], c = corners[(index + 2) % 4]
            turns.append((b.x - a.x) * (c.y - b.y) - (b.y - a.y) * (c.x - b.x))
            twiceArea += a.x * b.y - a.y * b.x
        }
        guard turns.allSatisfy({ $0 > 1e-8 }) || turns.allSatisfy({ $0 < -1e-8 }),
              abs(twiceArea) / 2 >= 1e-4,
              let forward = ProjectiveMap(squareTo: corners), let backward = forward.inverse else { return nil }
        self.corners = corners
        self.forward = forward
        self.backward = backward
    }

    /// Unit-square image region, not real-world distances or verified contact.
    public func tableCoordinates(of point: NormalizedPoint) -> NormalizedPoint? {
        backward.map(point)
    }

    public func imagePoint(at tablePoint: NormalizedPoint) -> NormalizedPoint? {
        forward.map(tablePoint)
    }
}

private struct ProjectiveMap: Sendable {
    let matrix: [Double]

    init?(squareTo p: [NormalizedPoint]) {
        let dx1 = p[1].x - p[2].x, dx2 = p[3].x - p[2].x
        let dy1 = p[1].y - p[2].y, dy2 = p[3].y - p[2].y
        let dx3 = p[0].x - p[1].x + p[2].x - p[3].x
        let dy3 = p[0].y - p[1].y + p[2].y - p[3].y
        var g = 0.0, h = 0.0
        if abs(dx3) + abs(dy3) > 1e-12 {
            let denominator = dx1 * dy2 - dx2 * dy1
            guard abs(denominator) > 1e-12 else { return nil }
            g = (dx3 * dy2 - dx2 * dy3) / denominator
            h = (dx1 * dy3 - dx3 * dy1) / denominator
        }
        matrix = [p[1].x - p[0].x + g * p[1].x, p[3].x - p[0].x + h * p[3].x, p[0].x,
                  p[1].y - p[0].y + g * p[1].y, p[3].y - p[0].y + h * p[3].y, p[0].y,
                  g, h, 1]
        guard matrix.allSatisfy(\.isFinite) else { return nil }
    }

    private init(matrix: [Double]) { self.matrix = matrix }

    var inverse: ProjectiveMap? {
        let m = matrix
        // Adjugate suffices: a homogeneous map is unchanged by a common scale.
        let adjugate = [m[4] * m[8] - m[5] * m[7], m[2] * m[7] - m[1] * m[8], m[1] * m[5] - m[2] * m[4],
                        m[5] * m[6] - m[3] * m[8], m[0] * m[8] - m[2] * m[6], m[2] * m[3] - m[0] * m[5],
                        m[3] * m[7] - m[4] * m[6], m[1] * m[6] - m[0] * m[7], m[0] * m[4] - m[1] * m[3]]
        let determinant = m[0] * adjugate[0] + m[1] * adjugate[3] + m[2] * adjugate[6]
        guard determinant.isFinite, abs(determinant) > 1e-12, adjugate.allSatisfy(\.isFinite) else { return nil }
        return ProjectiveMap(matrix: adjugate)
    }

    func map(_ point: NormalizedPoint) -> NormalizedPoint? {
        let denominator = matrix[6] * point.x + matrix[7] * point.y + matrix[8]
        guard denominator.isFinite, abs(denominator) > 1e-12 else { return nil }
        let x = (matrix[0] * point.x + matrix[1] * point.y + matrix[2]) / denominator
        let y = (matrix[3] * point.x + matrix[4] * point.y + matrix[5]) / denominator
        // Tolerance only for floating-point boundary roundoff, not contact gating.
        let epsilon = 1e-9
        guard x.isFinite, y.isFinite, x >= -epsilon, y >= -epsilon, x <= 1 + epsilon, y <= 1 + epsilon else { return nil }
        return NormalizedPoint(x: min(1, max(0, x)), y: min(1, max(0, y)))
    }
}

public enum AreaSelectionResult: Equatable, Sendable {
    case ignored, cornerAccepted(Int), ready, invalidPolygon
}

/// Session-only image geometry, never a saved frame or a landmark trajectory.
public struct PlayingAreaCalibration: Sendable {
    public private(set) var isSelecting = false
    public private(set) var draft: [NormalizedPoint] = []
    public private(set) var area: PlayingArea?

    public init() {}

    public mutating func begin() {
        reset()
        isSelecting = true
    }

    public mutating func select(_ point: NormalizedPoint) -> AreaSelectionResult {
        guard isSelecting else { return .ignored }
        draft.append(point)
        guard draft.count == 4 else { return .cornerAccepted(draft.count) }
        guard let result = PlayingArea(corners: draft) else {
            draft = []
            return .invalidPolygon
        }
        area = result
        isSelecting = false
        draft = []
        return .ready
    }

    public mutating func reset() {
        isSelecting = false
        draft = []
        area = nil
    }
}
