#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILButton (KitBridge)
#if IL_UI_KIT
@property(nonatomic, copy) NSString *title;
#endif

@end

NS_ASSUME_NONNULL_END
