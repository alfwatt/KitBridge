import Foundation

/* UIKit */
#if os(iOS)
import UIKit
public typealias ILApplication = UIApplication
public typealias ILApplicationDelegate = UIApplicationDelegate
public typealias ILBezierPath = UIBezierPath
public typealias ILButton = UIButton
public typealias ILColor = UIColor
public typealias ILFont = UIFont
public typealias ILGradient = NSObject
public typealias ILImage = UIImage
public typealias ILImageView = UIImageView
public typealias ILLabel = UILabel
public typealias ILPasteboard = UIPasteboard
public typealias ILProgressView = UIActivityIndicatorView
public typealias ILResponder = UIResponder
public typealias ILScreen = UIScreen
public typealias ILSlider = UISlider
public typealias ILSwitch = UISwitch
public typealias ILTextView = UITextView
public typealias ILTextField = UITextField
public typealias ILTableView = UITableView
public typealias ILTableViewCell = UITableViewCell
public typealias ILTableViewController = UITableViewController
public typealias ILView = UIView
public typealias ILViewController = UIViewController
public typealias ILWebView = UIWebView
public typealias ILWindow = UIWindow

/* AppKit */
#elseif os(macOS)
import AppKit
import WebKit
public typealias ILApplication = NSApplication
public typealias ILApplicationDelegate = NSApplicationDelegate
public typealias ILBezierPath = NSBezierPath
public typealias ILButton = NSButton
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
public typealias ILSwitch = NSButton
public typealias ILTextView = NSTextView
public typealias ILTextField = NSTextField
public typealias ILTableView = NSTableView
public typealias ILTableViewCell = NSView
public typealias ILTableViewController = NSViewController
public typealias ILView = NSView
public typealias ILViewController = NSViewController
public typealias ILWebView = WebView
public typealias ILWindow = NSWindow
#endif
