#ifndef KitBridgeDefines_h
#define KitBridgeDefines_h

#include <TargetConditionals.h>

/* UIKit */
#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILApplication UIApplication
#define ILApplicationDelegate UIApplicationDelegate
#define ILBezierPath UIBezierPath
#define ILBox UIView
#define ILButton UIButton
#define ILColor UIColor
#define ILFont UIFont
#define ILGradient NSObject // TODO Implement ILGradient on top of CGGradient
#define ILImage UIImage
#define ILImageView UIImageView
#define ILLabel UILabel
#define ILPasteboard UIPasteboard
#define ILProgressView UIActivityIndicatorView
#define ILResponder UIResponder
#define ILScreen UIScreen
#define ILSlider UISlider
#define ILSwitch UISwitch
#define ILTextView UITextView
#define ILTextField UITextField
#define ILTableView UITableView
#define ILTableViewCell UITableViewCell
#define ILTableViewController UITableViewController
#define ILView UIView
#define ILViewController UIViewController
#define ILWebView UIWebView
#define ILWindow UIWindow
#define ILWindowController NSObject // TODO implement ILWindowController for UIWindows
#define IL_UI_KIT 1

/* AppKit */
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#define ILApplication NSApplication
#define ILApplicationDelegate NSApplicationDelegate
#define ILBezierPath NSBezierPath
#define ILBox NSBox
#define ILButton NSButton
#define ILColor NSColor
#define ILFont NSFont
#define ILGradient NSGradient
#define ILImage NSImage
#define ILImageView NSImageView
#define ILLabel NSTextView
#define ILPasteboard NSPasteboard
#define ILPasteboardItem NSPasteboardItem
#define ILProgressView NSProgressIndicator
#define ILResponder NSResponder
#define ILScreen NSScreen
#define ILSlider NSSlider
#define ILSwitch NSButton
#define ILTextView NSTextView
#define ILTextField NSTextField
#define ILTableView NSTableView
#define ILTableViewCell NSView
#define ILTableViewController NSViewController
#define ILView NSView
#define ILViewController NSViewController
#define ILWebView WebView
#define ILWindow NSWindow
#define ILWindowController NSWindowController
#define IL_APP_KIT 1
#endif

#endif /* KitBridgeDefines_h */
