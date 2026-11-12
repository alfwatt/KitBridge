import Foundation
#if canImport(AppKit)
import AppKit
#elseif !os(watchOS)
import UIKit
#endif

#if !os(watchOS)

/// The common init and update methods of views, e.g. in SparkKit
@MainActor
public protocol ILViewLifecycle: AnyObject {
    /// initialize the view, from `init(frame:)` or `init(coder:)`
    func initView()
    /// have the view query its data source and redraw itself
    func updateView()
}

// MARK: -

@MainActor
public extension ILView {
    /// an image of the contents of the view as it is drawn now
    var renderedImage: ILImage? {
#if canImport(AppKit)
        guard let bitmap = bitmapImageRepForCachingDisplay(in: bounds) else { return nil }
        cacheDisplay(in: bounds, to: bitmap)
        let image = NSImage(size: bounds.size)
        image.addRepresentation(bitmap)
        return image
#else
        UIGraphicsImageRenderer(bounds: bounds).image { layer.render(in: $0.cgContext) }
#endif
    }

    /// replace the system fonts of the text in the view and its subviews with the application's font faces
    /// @see `ApplicationFontFace`
    func replaceSystemFonts() {
        if let text = self as? ILTextView, let font = text.font {
            text.font = ILFont.applicationFont(replacing: font)
        }
#if !canImport(AppKit)
        if let label = self as? UILabel {
            label.font = ILFont.applicationFont(replacing: label.font)
        }
#endif
        for subview in subviews {
            subview.replaceSystemFonts()
        }
    }
}

// MARK: - Drawing

#if canImport(AppKit)
@MainActor
public extension NSView {
    /// mark the whole view as needing to be drawn, as UIView does
    func setNeedsDisplay() {
        needsDisplay = true
    }
}
#endif

// MARK: - Text

#if canImport(AppKit)
@MainActor
public extension NSTextView {
    /// the text view's text, as UITextView has it
    var text: String {
        get { string }
        set { string = newValue }
    }
}

@MainActor
public extension NSTextField {
    /// the text field's text, as UITextField has it
    var text: String {
        get { stringValue }
        set { stringValue = newValue }
    }
}
#else
public extension NSTextStorage {
    /// the runs of text with the same attributes, as AppKit has them
    var attributeRuns: [NSAttributedString] {
        var runs: [NSAttributedString] = []
        enumerateAttributes(in: NSRange(location: 0, length: length)) { _, range, _ in
            runs.append(attributedSubstring(from: range))
        }
        return runs
    }
}
#endif

// MARK: - Applications, Storyboards and Controls

#if canImport(AppKit)
@MainActor
public extension NSApplication {
    /// open the
    /// @param url provided, as UIApplication does
    @discardableResult
    func open(_ url: URL) -> Bool {
        NSWorkspace.shared.open(url)
    }
}

@MainActor
public extension NSStoryboard {
    /// the storyboard's initial view controller, as UIStoryboard has it
    func instantiateInitialViewController() -> NSViewController? {
        instantiateInitialController() as? NSViewController
    }

    /// the view controller with the
    /// @param identifier provided, as UIStoryboard has it
    func instantiateViewController(withIdentifier identifier: String) -> NSViewController? {
        instantiateController(withIdentifier: identifier) as? NSViewController
    }
}

@MainActor
public extension NSProgressIndicator {
    /// start the indicator's animation, as UIActivityIndicatorView does
    func startAnimating() {
        startAnimation(nil)
    }

    /// stop the indicator's animation, as UIActivityIndicatorView does
    func stopAnimating() {
        stopAnimation(nil)
    }
}
#else
@MainActor
public extension UIApplication {
    /// send the
    /// @param action provided to the
    /// @param target provided, from the
    /// @param sender provided, or the application, as NSApplication does
    @discardableResult
    func sendAction(_ action: Selector, to target: Any?, from sender: Any?) -> Bool {
        sendAction(action, to: target, from: sender ?? self, for: nil)
    }
}

@MainActor
public extension UIButton {
    /// the button's title for its normal state, as NSButton has it
    var title: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
}
#endif

#endif // !os(watchOS)
