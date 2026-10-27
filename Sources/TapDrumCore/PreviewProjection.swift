/// A point in an unflipped AppKit/Core Animation coordinate space (y increases up).
public struct PreviewPoint: Equatable, Sendable {
    public let x: Double
    public let y: Double
}

/// Projects Vision's lower-left normalized points into the actual preview image
/// rectangle. Keeping this separate from capture-device top-left coordinates
/// prevents a second y inversion. Letterbox offsets and mirroring are explicit.
public struct PreviewProjection: Sendable {
    public let x: Double
    public let y: Double
    public let width: Double
    public let height: Double

    public init?(x: Double, y: Double, width: Double, height: Double) {
        guard x.isFinite, y.isFinite, width.isFinite, height.isFinite,
              width > 0, height > 0, (x + width).isFinite, (y + height).isFinite else { return nil }
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    public func project(_ point: NormalizedPoint, mirrored: Bool) -> PreviewPoint {
        PreviewPoint(x: x + (mirrored ? 1 - point.x : point.x) * width,
                     y: y + point.y * height)
    }

    public func unproject(x pointX: Double, y pointY: Double, mirrored: Bool) -> NormalizedPoint? {
        let u = (pointX - x) / width
        return NormalizedPoint(x: mirrored ? 1 - u : u, y: (pointY - y) / height)
    }
}
