#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// adds common init and update methods to all views in the SparkKit
@protocol ILViewLifecycle <NSObject>

/// run from initWithFrame: or initWithCoder: to initialize the view
- (void) initView;

/// have the view query it's data source and redraw itself
- (void) updateView;

@end

// MARK: -

@interface ILView (KitBridge)
/// an image with the contents of the view as currently configured
@property(nonatomic,readonly) ILImage* renderedImage;

/// descends through the view tree and replaces system fonts with font faces defined in Info.plist with the font face keys
/// @see ILFont\_KitBridge.h for details
- (void) replaceSystemFonts;

@end

NS_ASSUME_NONNULL_END
