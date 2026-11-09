import Foundation
import CoreGraphics
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

#if canImport(AppKit)
/// UIBezierPath's construction methods on NSBezierPath
public extension NSBezierPath {
    convenience init(roundedRect rect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    }

    /// an arc, with angles in radians, as UIBezierPath draws it
    convenience init(arcCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        self.init()
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    func addLine(to point: CGPoint) {
        line(to: point)
    }

    func addCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint) {
        curve(to: endPoint, controlPoint: controlPoint)
    }

    /// an arc, with angles in radians, as UIBezierPath draws it, in flipped coordinates, where clockwise is counter clockwise
    func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        appendArc(withCenter: center, radius: radius, startAngle: .degrees(fromRadians: startAngle),
                  endAngle: .degrees(fromRadians: endAngle), clockwise: !clockwise)
    }
}
#else
public extension UIBezierPath {
    /// the number of elements in the path, as NSBezierPath has it
    var elementCount: Int {
        cgPath.elementCount
    }
}
#endif

public extension ILBezierPath {
    /// call the
    /// @param body provided with each element of the path
    func forEachElement(_ body: (CGPathElement) -> Void) {
        cgPath.applyWithBlock { body($0.pointee) }
    }
}
