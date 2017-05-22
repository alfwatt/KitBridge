
//! Project version number for KitBridge.
FOUNDATION_EXPORT double KitBridgeVersionNumber;

//! Project version string for KitBridge.
FOUNDATION_EXPORT const unsigned char KitBridgeVersionString[];

/*

    iStumbler Labs UIKit & AppKit Bridging Header

    https://istumbler.net/labs/

*/
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#ifndef ILKitBridge_h
#define ILKitBridge_h
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
#define IL_APP_KIT 1
#endif

#endif /* ILKitBridge_h */


#pragma mark -

/*! @brief adds common init and update methods to all views in the SparkKit */
@protocol ILViews <NSObject>

/*! @brief run from initWithFrame: or initWithCoder: to initilzize the view */
- (void) initView;

/*! @brief have the view query it's data source and redraw itself */
- (void) updateView;

@end


