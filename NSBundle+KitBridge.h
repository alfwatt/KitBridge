#import <KitBridge/KitBridgeDefines.h>

NS_ASSUME_NONNULL_BEGIN
@class ILImage;

@interface NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage*) imageForResource:(NSString*)name;
#endif

@end

NS_ASSUME_NONNULL_END
