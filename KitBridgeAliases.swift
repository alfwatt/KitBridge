import Foundation

/* UIKit */
#if os(iOS)
import UIKit
typealias ILApplication = UIApplication
typealias ILApplicationDelegate = UIApplicationDelegate
typealias ILBezierPath = UIBezierPath
typealias ILButton = UIButton
typealias ILColor = UIColor
typealias ILFont = UIFont
typealias ILGradient = NSObject
typealias ILImage = UIImage
typealias ILImageView = UIImageView
typealias ILLabel = UILabel
typealias ILPasteboard = UIPasteboard
typealias ILProgressView = UIActivityIndicatorView
typealias ILResponder = UIResponder
typealias ILScreen = UIScreen
typealias ILSlider = UISlider
typealias ILSwitch = UISwitch
typealias ILTextView = UITextView
typealias ILTextField = UITextField
typealias ILTableView = UITableView
typealias ILTableViewCell = UITableViewCell
typealias ILTableViewController = UITableViewController
typealias ILView = UIView
typealias ILViewController = UIViewController
typealias ILWebView = UIWebView
typealias ILWindow = UIWindow

/* AppKit */
#elseif os(macOS)
import AppKit
import WebKit
typealias ILApplication = NSApplication
typealias ILApplicationDelegate = NSApplicationDelegate
typealias ILBezierPath = NSBezierPath
typealias ILButton = NSButton
typealias ILColor = NSColor
typealias ILFont = NSFont
typealias ILGradient = NSGradient
typealias ILImage = NSImage
typealias ILImageView = NSImageView
typealias ILLabel = NSTextView
typealias ILPasteboard = NSPasteboard
typealias ILPasteboardItem = NSPasteboardItem
typealias ILProgressView = NSProgressIndicator
typealias ILResponder = NSResponder
typealias ILScreen = NSScreen
typealias ILSlider = NSSlider
typealias ILSwitch = NSButton
typealias ILTextView = NSTextView
typealias ILTextField = NSTextField
typealias ILTableView = NSTableView
typealias ILTableViewCell = NSView
typealias ILTableViewController = NSViewController
typealias ILView = NSView
typealias ILViewController = NSViewController
typealias ILWebView = WebView
typealias ILWindow = NSWindow
#endif
