#import <KitBridge/KitBridgeDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface ILButton (KitBridge)
#ifdef IL_UI_KIT
@property(nonatomic, copy) NSString *title;
#endif

@end

NS_ASSUME_NONNULL_END
