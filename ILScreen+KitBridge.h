#import <KitBridge/KitBridgeDefines.h>

@interface ILScreen (KitBridge)

#ifdef IL_APP_KIT
#pragma mark - UIScreen methods

@property(nonatomic,readonly) CGFloat scale;

#endif

@end
