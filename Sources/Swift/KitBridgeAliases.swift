import Foundation

/* UIKit */
#if os(iOS)
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
public typealias ILGradient = NSObject
public typealias ILImage = UIImage
public typealias ILImageView = UIImageView
public typealias ILLabel = UILabel
public typealias ILPasteboard = UIPasteboard
public typealias ILProgressView = UIActivityIndicatorView
public typealias ILResponder = UIResponder
public typealias ILScreen = UIScreen
public typealias ILSlider = UISlider
public typealias ILStoryboard = UIStoryboard
public typealias ILSwitch = UISwitch
public typealias ILTextView = UITextView
public typealias ILTextField = UITextField
public typealias ILTableView = UITableView
public typealias ILTableViewCell = UITableViewCell
public typealias ILTableViewController = UITableViewController
public typealias ILView = UIView
public typealias ILViewController = UIViewController
public typealias ILWindow = UIWindow
public typealias ILWindowController = NSObject

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
