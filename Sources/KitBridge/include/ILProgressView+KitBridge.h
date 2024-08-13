#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILProgressView (KitBridge)

#if IL_APP_KIT
- (void)startAnimating;

- (void)stopAnimating;
#endif

@end

NS_ASSUME_NONNULL_END
