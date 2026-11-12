#if canImport(SwiftUI)
import Foundation
import SwiftUI
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

// MARK: - Drawing Types

public extension Color {
    /// the SwiftUI color of the kit's
    /// @param color provided
    init(ilColor color: ILColor) {
#if canImport(AppKit)
        self.init(nsColor: color)
#else
        self.init(uiColor: color)
#endif
    }
}

public extension Image {
    /// the SwiftUI image of the kit's
    /// @param image provided
    init(ilImage image: ILImage) {
#if canImport(AppKit)
        self.init(nsImage: image)
#else
        self.init(uiImage: image)
#endif
    }
}

public extension Font {
    /// the SwiftUI font of the kit's
    /// @param font provided
    init(ilFont font: ILFont) {
        self.init(font as CTFont)
    }
}

public extension Path {
    /// the SwiftUI path of the kit's
    /// @param path provided
    init(_ path: ILBezierPath) {
        self.init(path.cgPath)
    }
}

public extension ILBezierPath {
    /// the kit's path of the SwiftUI
    /// @param path provided
    convenience init(_ path: Path) {
        self.init(cgPath: path.cgPath)
    }
}

#if !os(watchOS)

// MARK: - View Representables

#if canImport(AppKit)
/// NSViewRepresentable and UIViewRepresentable with one spelling: declare the `ILViewType`, implement `makeView(context:)`
/// and `updateView(_:context:)`, and the representable hosts the view in SwiftUI on every platform with views;
/// Swift can't infer the `ILViewType` from `makeView(context:)`, declare it, e.g. `typealias ILViewType = ILDrawingView`
@MainActor
public protocol ILViewRepresentable: NSViewRepresentable where NSViewType == ILViewType {
    /// the type of the view, NSViewType or UIViewType
    associatedtype ILViewType: ILView
    /// make the view, as `makeNSView(context:)` and `makeUIView(context:)` do
    func makeView(context: Context) -> ILViewType
    /// update the view with the representable's values, as `updateNSView(_:context:)` and `updateUIView(_:context:)` do
    func updateView(_ view: ILViewType, context: Context)
    /// the size of the view for the proposal, or nil for the view's intrinsic size
    func sizeThatFits(_ proposal: ProposedViewSize, view: ILViewType, context: Context) -> CGSize?
    /// clean up the view, when SwiftUI removes it
    static func dismantleView(_ view: ILViewType, coordinator: Coordinator)
}

public extension ILViewRepresentable {
    func makeNSView(context: Context) -> NSViewType {
        makeView(context: context)
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateView(nsView, context: context)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSViewType, context: Context) -> CGSize? {
        sizeThatFits(proposal, view: nsView, context: context)
    }

    static func dismantleNSView(_ nsView: NSViewType, coordinator: Coordinator) {
        dismantleView(nsView, coordinator: coordinator)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, view: NSViewType, context: Context) -> CGSize? {
        nil
    }

    static func dismantleView(_ view: NSViewType, coordinator: Coordinator) {}
}
#else
/// NSViewRepresentable and UIViewRepresentable with one spelling: declare the `ILViewType`, implement `makeView(context:)`
/// and `updateView(_:context:)`, and the representable hosts the view in SwiftUI on every platform with views;
/// Swift can't infer the `ILViewType` from `makeView(context:)`, declare it, e.g. `typealias ILViewType = ILDrawingView`
@MainActor
public protocol ILViewRepresentable: UIViewRepresentable where UIViewType == ILViewType {
    /// the type of the view, NSViewType or UIViewType
    associatedtype ILViewType: ILView
    /// make the view, as `makeNSView(context:)` and `makeUIView(context:)` do
    func makeView(context: Context) -> ILViewType
    /// update the view with the representable's values, as `updateNSView(_:context:)` and `updateUIView(_:context:)` do
    func updateView(_ view: ILViewType, context: Context)
    /// the size of the view for the proposal, or nil for the view's intrinsic size
    func sizeThatFits(_ proposal: ProposedViewSize, view: ILViewType, context: Context) -> CGSize?
    /// clean up the view, when SwiftUI removes it
    static func dismantleView(_ view: ILViewType, coordinator: Coordinator)
}

public extension ILViewRepresentable {
    func makeUIView(context: Context) -> UIViewType {
        makeView(context: context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateView(uiView, context: context)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        sizeThatFits(proposal, view: uiView, context: context)
    }

    static func dismantleUIView(_ uiView: UIViewType, coordinator: Coordinator) {
        dismantleView(uiView, coordinator: coordinator)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, view: UIViewType, context: Context) -> CGSize? {
        nil
    }

    static func dismantleView(_ view: UIViewType, coordinator: Coordinator) {}
}
#endif

/// A view made and updated by blocks, in SwiftUI, e.g. `ILViewBridge { ILSparkLine() } update: { $0.dataSource = data }`
public struct ILViewBridge<BridgedView: ILView>: ILViewRepresentable {
    public typealias ILViewType = BridgedView

    private let make: () -> BridgedView
    private let update: (BridgedView) -> Void

    /// a view made by the
    /// @param make block provided, and updated with the representable's values by the
    /// @param update block provided
    public init(_ make: @escaping () -> BridgedView, update: @escaping (BridgedView) -> Void = { _ in }) {
        self.make = make
        self.update = update
    }

    public func makeView(context: Context) -> BridgedView {
        make()
    }

    public func updateView(_ view: BridgedView, context: Context) {
        update(view)
    }
}

#endif // !os(watchOS)

// MARK: - Drawing in SwiftUI

/// An ILDrawing in SwiftUI: an ILDrawingView where the platform has views, a Canvas on the watch
public struct ILDrawingCanvas: View {
    /// the drawing on the canvas
    public let drawing: any ILDrawing

    /// does the drawing fill the canvas with opaque colors?
    public let opaque: Bool

    /// a canvas with the
    /// @param drawing provided, which is
    /// @param opaque or not
    public init(_ drawing: any ILDrawing, opaque: Bool = false) {
        self.drawing = drawing
        self.opaque = opaque
    }

    public var body: some View {
#if os(watchOS)
        Canvas(opaque: opaque) { context, size in
            context.withCGContext { cgContext in
                ILGraphicsContext.drawing(in: cgContext) {
                    drawing.draw(in: CGRect(origin: .zero, size: size), context: cgContext)
                }
            }
        }
#else
        ILViewBridge { ILDrawingView() } update: { view in
            view.drawsOpaque = opaque
            view.drawing = drawing
        }
#endif
    }
}

#endif // canImport(SwiftUI)
