#ifndef KitBridgeDefines_h
#define KitBridgeDefines_h

#include <TargetConditionals.h>

/* UIKit */
#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILScreen UIScreen
#define ILResponder UIResponder
#define ILColor UIColor
#define ILGradient NSObject // TODO Implement ILGradient on top of CGGradient
#define ILFont UIFont
#define ILImage UIImage
#define ILView UIView
#define ILWindow UIWindow
#define ILApplicationDelegate UIApplicationDelegate
#define ILBezierPath UIBezierPath
#define ILTextView UITextView
#define ILPasteboard UIPasteboard
#define IL_UI_KIT 1

/* AppKit */
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define ILScreen NSScreen
#define ILResponder NSResponder
#define ILColor NSColor
#define ILGradient NSGradient
#define ILFont NSFont
#define ILImage NSImage
#define ILView NSView
#define ILWindow NSWindow
#define ILApplicationDelegate NSApplicationDelegate
#define ILGradient NSGradient
#define ILBezierPath NSBezierPath
#define ILTextView NSTextView
#define ILPasteboard NSPasteboard
#define ILPasteboardItem NSPasteboardItem
#define IL_APP_KIT 1
#endif

#endif /* KitBridgeDefines_h */
