import Foundation

/* WatchKit: UIKit's drawing types only */
#if os(watchOS)
import UIKit
import WatchKit
public typealias ILBezierPath = UIBezierPath
public typealias ILColor = UIColor
public typealias ILFont = UIFont
public typealias ILImage = UIImage

/* UIKit */
#elseif os(iOS) || os(tvOS) || os(visionOS)
import UIKit
public typealias ILApplication = UIApplication
public typealias ILApplicationDelegate = UIApplicationDelegate
public typealias ILBezierPath = UIBezierPath
public typealias ILBox = UIView
public typealias ILButton = UIButton
public typealias ILCollectionView = UICollectionView
public typealias ILCollectionViewCell = UICollectionViewCell
public typealias ILCollectionViewDelegate = UICollectionViewDelegate
public typealias ILColor = UIColor
public typealias ILFont = UIFont
public typealias ILImage = UIImage
public typealias ILImageView = UIImageView
public typealias ILLabel = UILabel
public typealias ILProgressView = UIActivityIndicatorView
public typealias ILResponder = UIResponder
#if !os(visionOS) // visionOS has no UIScreen, KitBridge's ILScreen class stands in
public typealias ILScreen = UIScreen
#endif
public typealias ILStoryboard = UIStoryboard
public typealias ILTextView = UITextView
public typealias ILTextField = UITextField
public typealias ILTableView = UITableView
public typealias ILTableViewCell = UITableViewCell
public typealias ILTableViewController = UITableViewController
public typealias ILView = UIView
public typealias ILViewController = UIViewController
public typealias ILWindow = UIWindow
public typealias ILWindowController = NSObject
#if os(iOS) || os(visionOS) // tvOS has no pasteboard, sliders or switches
public typealias ILPasteboard = UIPasteboard
public typealias ILSlider = UISlider
public typealias ILSwitch = UISwitch
#endif

/* AppKit */
#elseif os(macOS)
import AppKit
public typealias ILApplication = NSApplication
public typealias ILApplicationDelegate = NSApplicationDelegate
public typealias ILBezierPath = NSBezierPath
public typealias ILBox = NSBox
public typealias ILButton = NSButton
public typealias ILCollectionView = NSCollectionView
public typealias ILCollectionViewCell = NSCollectionViewItem
public typealias ILCollectionViewDelegate = NSCollectionViewDelegate
public typealias ILColor = NSColor
public typealias ILFont = NSFont
public typealias ILGradient = NSGradient
public typealias ILImage = NSImage
public typealias ILImageView = NSImageView
public typealias ILLabel = NSTextView
public typealias ILPasteboard = NSPasteboard
public typealias ILPasteboardItem = NSPasteboardItem
public typealias ILProgressView = NSProgressIndicator
public typealias ILResponder = NSResponder
public typealias ILScreen = NSScreen
public typealias ILSlider = NSSlider
public typealias ILStoryboard = NSStoryboard
public typealias ILSwitch = NSButton
public typealias ILTextView = NSTextView
public typealias ILTextField = NSTextField
public typealias ILTableView = NSTableView
public typealias ILTableViewCell = NSView
public typealias ILTableViewController = NSViewController
public typealias ILView = NSView
public typealias ILViewController = NSViewController
public typealias ILWindow = NSWindow
public typealias ILWindowController = NSWindowController
#endif

// MARK: - Screens

#if os(watchOS) || os(visionOS)
/// The watch and visionOS have no UIScreen, ILScreen stands in with the scale images are drawn at
public final class ILScreen: Sendable {
    public static let main = ILScreen()

    /// the scale of the display: the watch's, visionOS renders at a fixed 2x
    public var scale: CGFloat {
#if os(watchOS)
        WKInterfaceDevice.current().screenScale
#else
        2
#endif
    }
}
#elseif os(macOS)
public extension NSScreen {
    /// the screen's backing scale factor, as UIScreen names it
    var scale: CGFloat { backingScaleFactor }
}
#endif

public extension ILScreen {
    /// the scale of the main screen, 1 if there isn't one, from any thread
    nonisolated static var mainScale: CGFloat {
#if os(macOS) || os(iOS) || os(tvOS)
        if Thread.isMainThread {
            return MainActor.assumeIsolated { mainScreenScale }
        }
        return DispatchQueue.main.sync { MainActor.assumeIsolated { mainScreenScale } }
#else
        ILScreen.main.scale
#endif
    }

#if os(macOS) || os(iOS) || os(tvOS)
    @MainActor
    private static var mainScreenScale: CGFloat {
#if os(macOS)
        NSScreen.main?.backingScaleFactor ?? 1
#else
        UIScreen.main.scale
#endif
    }
#endif
}
