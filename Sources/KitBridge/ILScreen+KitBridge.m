#import "ILScreen+KitBridge.h"

@implementation ILScreen (KitBridge)

#if IL_APP_KIT
- (CGFloat) scale {
    return self.backingScaleFactor;
}
#endif

@end
