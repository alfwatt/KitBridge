#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

@interface ILScreen (KitBridge)

#if IL_APP_KIT
// MARK: - UIScreen methods

@property(nonatomic,readonly) CGFloat scale;

#endif

@end
