#ifndef KitBridgeDefines_h
#define KitBridgeDefines_h

#include <TargetConditionals.h>

/* UIKit */
#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILColor UIColor
#define ILGradient NSObject // TODO Implement ILGradient on top of CGGradient
#define ILFont UIFont
#define ILImage UIImage
#define ILView UIView
#define ILWindow UIWindow
#define ILViewController UIViewController
#define ILApplicationDelegate UIApplicationDelegate
#define ILBezierPath UIBezierPath
#define IL_UI_KIT 1

/* AppKit */
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define ILColor NSColor
#define ILGradient NSGradient
#define ILFont NSFont
#define ILImage NSImage
#define ILView NSView
#define ILWindow NSWindow
#define ILViewController NSViewController
#define ILApplicationDelegate NSApplicationDelegate
#define ILGradient NSGradient
#define ILBezierPath NSBezierPath
#define IL_APP_KIT 1
#endif

#endif /* KitBridgeDefines_h */
