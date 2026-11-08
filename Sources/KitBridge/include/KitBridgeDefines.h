#ifndef KitBridgeDefines_h
#define KitBridgeDefines_h

#include <TargetConditionals.h>

// WatchKit: UIKit's drawing types only, no views, controls, screens or application
#if TARGET_OS_WATCH
#import <UIKit/UIKit.h>
#define ILBezierPath                UIBezierPath
#define ILColor                     UIColor
#define ILFont                      UIFont
#define ILImage                     UIImage
/// watchOS has no UIScreen, so ILScreen is a minimal stand-in with the device's scale
@interface ILScreen : NSObject
@property(class, nonatomic, readonly, nonnull) ILScreen *mainScreen NS_SWIFT_NAME(main);
@property(nonatomic, readonly) CGFloat scale;
@end
#define IL_UI_KIT 1    // the UIKit branches of the drawing categories apply on the watch
#define IL_WATCH_KIT 1 // except where they use the UIKit the watch doesn't have

// UIKit
#elif TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#define ILApplication               UIApplication
#define ILApplicationDelegate       UIApplicationDelegate
#define ILBezierPath                UIBezierPath
#define ILBox                       UIView
#define ILButton                    UIButton
#define ILCollectionView            UICollectionView
#define ILCollectionViewItem        UICollectionViewItem
#define ILCollectionViewDelegate    UICollectionViewDelegate
#define ILColor                     UIColor
#define ILFont                      UIFont
#define ILGradient                  NSObject // TODO: Implement ILGradient on top of CGGradient
#define ILImage                     UIImage
#define ILImageView                 UIImageView
#define ILLabel                     UILabel
#define ILPasteboard                UIPasteboard
#define ILPasteBoardItem            NSDictionary<NSString*,id>
#define ILProgressView              UIActivityIndicatorView
#define ILResponder                 UIResponder
#if TARGET_OS_VISION
// visionOS has no UIScreen, so ILScreen is a minimal stand-in with a scale
@interface ILScreen : NSObject
@property(class, nonatomic, readonly, nonnull) ILScreen *mainScreen NS_SWIFT_NAME(main);
@property(nonatomic, readonly) CGFloat scale;
@end
#else
#define ILScreen                    UIScreen
#endif
#define ILStoryboard                UIStoryboard
#define ILSlider                    UISlider
#define ILSwitch                    UISwitch
#define ILTextView                  UITextView
#define ILTextField                 UITextField
#define ILTableView                 UITableView
#define ILTableViewCell             UITableViewCell
#define ILTableViewController       UITableViewController
#define ILView                      UIView
#define ILViewController            UIViewController
#define ILWindow                    UIWindow
#define ILWindowController          NSObject // TODO: implement ILWindowController for UIWindows
#define IL_UI_KIT 1

// AppKit
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#define ILApplication               NSApplication
#define ILApplicationDelegate       NSApplicationDelegate
#define ILBezierPath                NSBezierPath
#define ILBox                       NSBox
#define ILButton                    NSButton
#define ILCollectionView            NSCollectionView
#define ILCollectionViewItem        NSCollectionViewItem
#define ILCollectionViewDelegate    NSCollectionViewDelegate
#define ILColor                     NSColor
#define ILFont                      NSFont
#define ILGradient                  NSGradient
#define ILImage                     NSImage
#define ILImageView                 NSImageView
#define ILLabel                     NSTextView
#define ILPasteboard                NSPasteboard
#define ILPasteboardItem            NSPasteboardItem
#define ILProgressView              NSProgressIndicator
#define ILResponder                 NSResponder
#define ILScreen                    NSScreen
#define ILStoryboard                NSStoryboard
#define ILSlider                    NSSlider
#define ILSwitch                    NSButton
#define ILTextView                  NSTextView
#define ILTextField                 NSTextField
#define ILTableView                 NSTableView
#define ILTableViewCell             NSView
#define ILTableViewController       NSViewController
#define ILView                      NSView
#define ILViewController            NSViewController
#define ILWindow                    NSWindow
#define ILWindowController          NSWindowController
#define IL_APP_KIT 1
#endif

#endif /* KitBridgeDefines_h */
