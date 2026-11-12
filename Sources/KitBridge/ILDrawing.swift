import Foundation
import CoreGraphics
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

// MARK: - Graphics Contexts

/// The graphics context the kit is drawing into, with one spelling
public enum ILGraphicsContext {
    /// the CGContext AppKit or UIKit is drawing into now, if any
    public static var current: CGContext? {
#if canImport(AppKit)
        NSGraphicsContext.current?.cgContext
#else
        UIGraphicsGetCurrentContext()
#endif
    }

    /// make the
    /// @param context provided current while calling the
    /// @param body provided, so ILBezierPath, ILColor.set(), ILImage.draw and string drawing draw into it,
    /// the context's origin is top left, as UIKit has it
    public static func drawing<Result>(in context: CGContext, _ body: () throws -> Result) rethrows -> Result {
#if canImport(AppKit)
        NSGraphicsContext.saveGraphicsState()
        defer { NSGraphicsContext.restoreGraphicsState() }
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: true)
#else
        UIGraphicsPushContext(context)
        defer { UIGraphicsPopContext() }
#endif
        return try body()
    }
}

public extension ILImage {
    /// a bitmap image of the
    /// @param size provided, in points, at the
    /// @param scale provided, which is
    /// @param opaque or not, drawn by the
    /// @param draw block provided into a context with its origin top left, which is current for the kit's drawing,
    /// or nil if it can't be drawn; it doesn't need the main thread, e.g. to draw table rows ahead of time
    static func rendered(size: CGSize, scale: CGFloat = ILScreen.mainScale, opaque: Bool = false,
                         _ draw: (CGContext) -> Void) -> ILImage? {
        let width = Int((size.width * scale).rounded(.up)), height = Int((size.height * scale).rounded(.up))
        let alpha: CGImageAlphaInfo = opaque ? .noneSkipFirst : .premultipliedFirst
        guard width > 0, height > 0, let space = CGColorSpace(name: CGColorSpace.sRGB),
              let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: space,
                                      bitmapInfo: alpha.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            return nil
        }
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: scale, y: -scale)
        ILGraphicsContext.drawing(in: context) { draw(context) }
        guard let image = context.makeImage() else { return nil }
#if canImport(AppKit)
        return NSImage(cgImage: image, size: size)
#else
        return UIImage(cgImage: image, scale: scale, orientation: .up)
#endif
    }
}

// MARK: - Drawing

/// Drawing which can be done in an ILDrawingView, an ILDrawingCell in a table on the Mac, an image, or SwiftUI,
/// with the same code on every platform
public protocol ILDrawing {
    /// draw in the
    /// @param rect provided of the
    /// @param context provided, which has its origin top left, as UIKit has it, and is current for the kit's drawing
    func draw(in rect: CGRect, context: CGContext)
}

/// A block which draws, as an ILDrawing
public struct ILDrawingBlock: ILDrawing {
    private let block: (CGRect, CGContext) -> Void

    /// the drawing done by the
    /// @param block provided, with the rect and context to draw in
    public init(_ block: @escaping (CGRect, CGContext) -> Void) {
        self.block = block
    }

    public func draw(in rect: CGRect, context: CGContext) {
        block(rect, context)
    }
}

public extension ILDrawing {
    /// an image of the drawing at the
    /// @param size provided, in points, at the
    /// @param scale provided, which is
    /// @param opaque or not, e.g. to cache rows which don't change
    func image(size: CGSize, scale: CGFloat = ILScreen.mainScale, opaque: Bool = false) -> ILImage? {
        ILImage.rendered(size: size, scale: scale, opaque: opaque) { context in
            draw(in: CGRect(origin: .zero, size: size), context: context)
        }
    }
}

#if !os(watchOS)

// MARK: - Drawing Views

/// A view which draws an ILDrawing, set up to draw only when its drawing changes or it's resized, e.g. in table cells:
/// on the Mac it's layer backed and flipped, so scrolling a table composites the layers it has drawn without drawing them again
@objc(ILDrawingView)
open class ILDrawingView: ILView, ILViewLifecycle {

    /// the drawing in the view, setting it draws the view again
    open var drawing: (any ILDrawing)? {
        didSet { updateView() }
    }

    /// does the drawing fill the whole view with opaque colors? lets the kit skip compositing what's behind the view
    @objc open var drawsOpaque = false {
        didSet {
#if !canImport(AppKit)
            isOpaque = drawsOpaque
#endif
            updateView()
        }
    }

    /// does the view's layer draw on a background thread? can be faster for drawings with many fills or images
    @objc open var drawsAsynchronously: Bool {
        get { drawingLayer?.drawsAsynchronously ?? false }
        set { drawingLayer?.drawsAsynchronously = newValue }
    }

    /// the view's layer, which it always has
    private var drawingLayer: CALayer? {
#if canImport(AppKit)
        layer // set in initView
#else
        layer
#endif
    }

    /// a view drawing the
    /// @param drawing provided, in the
    /// @param frame provided
    public convenience init(drawing: any ILDrawing, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.drawing = drawing
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    // MARK: - ILViewLifecycle

    @objc open func initView() {
#if canImport(AppKit)
        wantsLayer = true
        layerContentsRedrawPolicy = .duringViewResize // draw again when resized, e.g. a table column, not when scrolled
#else
        contentMode = .redraw // draw again when resized, rather than stretching
        isOpaque = drawsOpaque
        backgroundColor = nil
#endif
    }

    @objc open func updateView() {
        setNeedsDisplay()
    }

#if canImport(AppKit)
    // MARK: - NSView

    open override var isFlipped: Bool { true }

    open override var isOpaque: Bool { drawsOpaque }

    open override func draw(_ dirtyRect: NSRect) {
        guard let drawing, let context = ILGraphicsContext.current else { return }
        drawing.draw(in: bounds, context: context)
    }
#else
    // MARK: - UIView

    open override func draw(_ rect: CGRect) {
        guard let drawing, let context = ILGraphicsContext.current else { return }
        drawing.draw(in: bounds, context: context)
    }
#endif
}

#endif // !os(watchOS)

#if os(macOS)

// MARK: - Drawing Cells

/// A cell which draws its object value, or its represented object, when it's an ILDrawing, e.g. in a cell based NSTableView,
/// the quickest way to draw many rows on the Mac: the table draws each row's value with one cell, without a view or layer for each
@objc(ILDrawingCell)
open class ILDrawingCell: NSCell {

    // MARK: - NSCell

    open override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard let drawing = (objectValue as? any ILDrawing) ?? (representedObject as? any ILDrawing),
              let context = ILGraphicsContext.current else {
            return
        }
        context.saveGState()
        defer { context.restoreGState() }
        context.clip(to: cellFrame)
        if !controlView.isFlipped { // flip the cell's frame in place, so the drawing's origin is top left
            context.translateBy(x: 0, y: cellFrame.minY + cellFrame.maxY)
            context.scaleBy(x: 1, y: -1)
        }
        ILGraphicsContext.drawing(in: context) {
            drawing.draw(in: cellFrame, context: context)
        }
    }
}

#endif
