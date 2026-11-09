import Foundation
import CoreGraphics

// MARK: - Angles

public extension CGFloat {
    /// the angle of the 12 o'clock position, in radians
    static let twelveOClock: CGFloat = -(.pi / 2)

    /// @returns the
    /// @param degrees provided in radians
    static func radians(fromDegrees degrees: CGFloat) -> CGFloat {
        degrees * .pi / 180
    }

    /// @returns the
    /// @param radians provided in degrees
    static func degrees(fromRadians radians: CGFloat) -> CGFloat {
        radians * 180 / .pi
    }

    /// @returns the
    /// @param percent of a circle provided, from 0 to 1, in radians
    static func radians(fromPercent percent: CGFloat) -> CGFloat {
        percent * 2 * .pi
    }
}

// MARK: - Vectors

public extension CGVector {
    /// the vector from one point to another
    init(from: CGPoint, to: CGPoint) {
        self.init(dx: to.x - from.x, dy: to.y - from.y)
    }

    /// the length of the vector
    var length: CGFloat {
        (dx * dx + dy * dy).squareRoot()
    }

    /// the angle of the vector in radians, counter clockwise from the positive x axis
    var radians: CGFloat {
        atan2(dy, dx)
    }
}

// MARK: - Points, Sizes and Rects

public extension CGPoint {
    /// @returns the point the
    /// @param distance provided from this point toward the
    /// @param point provided
    func moved(toward point: CGPoint, distance: CGFloat) -> CGPoint {
        let vector = CGVector(from: self, to: point)
        let length = vector.length
        guard length > 0 else { return self }
        return CGPoint(x: x + vector.dx / length * distance, y: y + vector.dy / length * distance)
    }

    /// is neither coordinate NaN, infinite or subnormal?
    var isNormal: Bool {
        (x.isZero || x.isNormal) && (y.isZero || y.isNormal)
    }
}

public extension CGSize {
    /// is neither dimension NaN, infinite or subnormal?
    var isNormal: Bool {
        (width.isZero || width.isNormal) && (height.isZero || height.isNormal)
    }
}

public extension CGRect {
    /// the center of the rect
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    /// the largest square centered in the rect, on integral coordinates
    var largestCenteredSquare: CGRect {
        let side = Swift.min(width, height)
        return CGRect(x: minX + (width - side) / 2, y: minY + (height - side) / 2, width: side, height: side).integral
    }

    /// are the origin and size normal?
    var isNormal: Bool {
        origin.isNormal && size.isNormal
    }
}

// MARK: - Paths

public extension CGPath {
    /// the number of elements in the path
    var elementCount: Int {
        var count = 0
        applyWithBlock { _ in count += 1 }
        return count
    }

    /// the path's bounds and elements, in PostScript order, e.g. "10.0 20.0 moveto"
    var pathDescription: String {
        var description = "<CGPath: bounds: \(boundingBoxOfPath) control points: \(boundingBox)\n"
        applyWithBlock { element in
            let points = element.pointee.points
            func coordinates(_ count: Int) -> String {
                (0..<count).map { "\(points[$0].x) \(points[$0].y)" }.joined(separator: " ")
            }
            switch element.pointee.type {
            case .moveToPoint: description += "  \(coordinates(1)) moveto\n"
            case .addLineToPoint: description += "  \(coordinates(1)) lineto\n"
            case .addQuadCurveToPoint: description += "  \(coordinates(2)) quadcurveto\n"
            case .addCurveToPoint: description += "  \(coordinates(3)) curveto\n"
            case .closeSubpath: description += "  closepath\n"
            @unknown default: description += "  unknown\n"
            }
        }
        return description + ">"
    }
}
