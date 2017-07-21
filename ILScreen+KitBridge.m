#import "ILScreen+KitBridge.h"

@implementation ILScreen (KitBridge)

#ifdef IL_APP_KIT

- (CGFloat) scale
{
    return self.backingScaleFactor;
}

#endif

@end
