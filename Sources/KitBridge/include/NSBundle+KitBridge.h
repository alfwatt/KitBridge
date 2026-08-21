#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

NS_ASSUME_NONNULL_BEGIN
@class ILImage;

@interface NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage*) imageForResource:(NSString*)name;
#endif

@end

NS_ASSUME_NONNULL_END
