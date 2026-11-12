import Foundation
import CoreGraphics
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

#if !canImport(AppKit)
/// NSGradient's API on CGGradient, for UIKit and the watch, drawn into the current context
open class ILGradient: NSObject {
    /// the colors of the gradient's stops
    public let colors: [ILColor]

    /// the locations of the gradient's stops, from 0 to 1
    public let locations: [CGFloat]

    /// the gradient, for drawing in a CGContext
    public let cgGradient: CGGradient

    /// a gradient from the
    /// @param starting color to the
    /// @param ending color provided, as NSGradient has it
    public convenience init?(starting: ILColor, ending: ILColor) {
        self.init(colors: [starting, ending])
    }

    /// a gradient through the
    /// @param colors provided, evenly spaced, as NSGradient has it
    public convenience init?(colors: [ILColor]) {
        guard colors.count >= 2 else { return nil }
        let last = CGFloat(colors.count - 1)
        self.init(colors: colors, locations: colors.indices.map { CGFloat($0) / last })
    }

    /// a gradient through the
    /// @param colors provided at the
    /// @param locations provided, from 0 to 1, one for each color
    public init?(colors: [ILColor], locations: [CGFloat]) {
        guard colors.count >= 2, colors.count == locations.count,
              let space = CGColorSpace(name: CGColorSpace.sRGB),
              let gradient = CGGradient(colorsSpace: space, colors: colors.map(\.cgColor) as CFArray, locations: locations) else {
            return nil
        }
        self.colors = colors
        self.locations = locations
        self.cgGradient = gradient
        super.init()
    }

    /// the number of stops in the gradient, as NSGradient has it
    public var numberOfColorStops: Int {
        colors.count
    }

    /// the color at the
    /// @param location provided, from 0 to 1, as NSGradient has it
    public func interpolatedColor(atLocation location: CGFloat) -> ILColor {
        guard let after = locations.firstIndex(where: { $0 >= location }) else { return colors[colors.count - 1] }
        guard after > 0 else { return colors[0] }
        let before = after - 1
        let span = locations[after] - locations[before]
        let fraction = span > 0 ? (location - locations[before]) / span : 0
        var from: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        var to: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        colors[before].getRed(&from.r, green: &from.g, blue: &from.b, alpha: &from.a)
        colors[after].getRed(&to.r, green: &to.g, blue: &to.b, alpha: &to.a)
        func mix(_ from: CGFloat, _ to: CGFloat) -> CGFloat { from + (to - from) * fraction }
        return ILColor(red: mix(from.r, to.r), green: mix(from.g, to.g), blue: mix(from.b, to.b), alpha: mix(from.a, to.a))
    }

    /// fill the
    /// @param rect provided with the gradient at the
    /// @param angle provided, in degrees, as NSGradient draws it
    public func draw(in rect: CGRect, angle: CGFloat) {
        guard let context = ILGraphicsContext.current else { return }
        context.saveGState()
        defer { context.restoreGState() }
        context.clip(to: rect)
        drawLinear(in: rect, angle: angle, context: context)
    }

    /// fill the
    /// @param path provided with the gradient at the
    /// @param angle provided, in degrees, as NSGradient draws it
    public func draw(in path: ILBezierPath, angle: CGFloat) {
        guard let context = ILGraphicsContext.current else { return }
        context.saveGState()
        defer { context.restoreGState() }
        context.addPath(path.cgPath)
        context.clip(using: path.usesEvenOddFillRule ? .evenOdd : .winding)
        drawLinear(in: path.bounds, angle: angle, context: context)
    }

    /// draw the gradient
    /// @param from the point provided
    /// @param to the point provided, with the
    /// @param options provided, as NSGradient draws it
    public func draw(from startingPoint: CGPoint, to endingPoint: CGPoint, options: CGGradientDrawingOptions) {
        ILGraphicsContext.current?.drawLinearGradient(cgGradient, start: startingPoint, end: endingPoint, options: options)
    }

    /// draw the gradient between the circles at the
    /// @param fromCenter with the
    /// @param fromRadius and the
    /// @param toCenter with the
    /// @param toRadius provided, with the
    /// @param options provided, as NSGradient draws it
    public func draw(fromCenter: CGPoint, radius fromRadius: CGFloat, toCenter: CGPoint, radius toRadius: CGFloat,
                     options: CGGradientDrawingOptions) {
        ILGraphicsContext.current?.drawRadialGradient(cgGradient, startCenter: fromCenter, startRadius: fromRadius,
                                                      endCenter: toCenter, endRadius: toRadius, options: options)
    }

    /// draw the gradient across the whole
    /// @param rect provided at the
    /// @param angle provided, in degrees, from its first stop to its last, into the
    /// @param context provided
    private func drawLinear(in rect: CGRect, angle: CGFloat, context: CGContext) {
        let radians = CGFloat.radians(fromDegrees: angle)
        let direction = CGVector(dx: cos(radians), dy: sin(radians))
        let reach = (abs(rect.width * direction.dx) + abs(rect.height * direction.dy)) / 2
        let center = rect.center
        let start = CGPoint(x: center.x - direction.dx * reach, y: center.y - direction.dy * reach)
        let end = CGPoint(x: center.x + direction.dx * reach, y: center.y + direction.dy * reach)
        context.drawLinearGradient(cgGradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }
}
#else
public extension NSGradient {
    /// a gradient through the
    /// @param colors provided at the
    /// @param locations provided, from 0 to 1, one for each color, as ILGradient has it on UIKit
    convenience init?(colors: [NSColor], locations: [CGFloat]) {
        guard colors.count == locations.count else { return nil }
        self.init(colors: colors, atLocations: locations, colorSpace: .sRGB)
    }

    /// the colors of the gradient's stops
    var colors: [NSColor] {
        stops.map(\.color)
    }

    /// the locations of the gradient's stops, from 0 to 1
    var locations: [CGFloat] {
        stops.map(\.location)
    }

    /// the gradient, for drawing in a CGContext
    var cgGradient: CGGradient? {
        let stops = stops
        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        return CGGradient(colorsSpace: space, colors: stops.map(\.color.cgColor) as CFArray, locations: stops.map(\.location))
    }

    private var stops: [(color: NSColor, location: CGFloat)] {
        (0..<numberOfColorStops).map { index in
            var color = NSColor.clear
            var location: CGFloat = 0
            getColor(&color, location: &location, at: index)
            return (color, location)
        }
    }
}
#endif
