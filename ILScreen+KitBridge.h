#import <KitBridge/KitBridgeDefines.h>

@interface ILScreen (KitBridge)

#if IL_APP_KIT
#pragma mark - UIScreen methods

@property(nonatomic,readonly) CGFloat scale;

#endif

@end
