#if SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILApplication (KitBridge)

#if IL_APP_KIT
- (BOOL)openURL:(NSURL *)url;
#endif

@end

NS_ASSUME_NONNULL_END
