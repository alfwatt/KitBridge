#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface ILButton (KitBridge)
#if IL_UI_KIT
@property(nonatomic, copy) NSString *title;
#endif

@end

NS_ASSUME_NONNULL_END
