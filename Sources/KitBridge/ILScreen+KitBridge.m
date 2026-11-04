#import "ILScreen+KitBridge.h"

#if TARGET_OS_VISION
@implementation ILScreen

+ (ILScreen *) mainScreen {
    static ILScreen *screen;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ screen = [ILScreen new]; });
    return screen;
}

- (CGFloat) scale {
    return 2; // visionOS renders at a fixed 2x
}

@end
#endif

@implementation ILScreen (KitBridge)

#if IL_APP_KIT
- (CGFloat) scale {
    return self.backingScaleFactor;
}
#endif

@end
