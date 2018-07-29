#ifndef KitBridgeDefines_h
#define KitBridgeDefines_h

#include <TargetConditionals.h>

/* UIKit */
#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILApplication UIApplication
#define ILApplicationDelegate UIApplicationDelegate
#define ILBezierPath UIBezierPath
#define ILButton UIButton
#define ILColor UIColor
#define ILFont UIFont
#define ILGradient NSObject // TODO Implement ILGradient on top of CGGradient
#define ILImage UIImage
#define ILLabel UILabel
#define ILPasteboard UIPasteboard
#define ILProgressView UIActivityIndicatorView
#define ILResponder UIResponder
#define ILScreen UIScreen
#define ILTextView UITextView
#define ILTextField UITextField
#define ILView UIView
#define ILViewController UIViewController
#define ILWindow UIWindow
#define IL_UI_KIT 1

/* AppKit */
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define ILApplication NSApplication
#define ILApplicationDelegate NSApplicationDelegate
#define ILBezierPath NSBezierPath
#define ILButton NSButton
#define ILColor NSColor
#define ILFont NSFont
#define ILGradient NSGradient
#define ILImage NSImage
#define ILLabel NSTextView
#define ILPasteboard NSPasteboard
#define ILPasteboardItem NSPasteboardItem
#define ILProgressView NSProgressIndicator
#define ILResponder NSResponder
#define ILScreen NSScreen
#define ILTextView NSTextView
#define ILTextField NSTextField
#define ILView NSView
#define ILViewController NSViewController
#define ILWindow NSWindow
#define IL_APP_KIT 1
#endif

#endif /* KitBridgeDefines_h */
