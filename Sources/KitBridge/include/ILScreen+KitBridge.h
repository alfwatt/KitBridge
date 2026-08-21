#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

@interface ILScreen (KitBridge)

#if IL_APP_KIT
// MARK: - UIScreen methods

@property(nonatomic,readonly) CGFloat scale;

#endif

@end
