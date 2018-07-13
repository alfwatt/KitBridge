#import <KitBridge/KitBridgeDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface ILProgressView (KitBridge)

#if IL_APP_KIT
- (void)startAnimating;

- (void)stopAnimating;
#endif

@end

NS_ASSUME_NONNULL_END
