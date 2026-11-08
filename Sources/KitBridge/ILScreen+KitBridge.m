#import "ILScreen+KitBridge.h"
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

#if TARGET_OS_VISION || TARGET_OS_WATCH
@implementation ILScreen

+ (ILScreen *) mainScreen {
    static ILScreen *screen;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ screen = [ILScreen new]; });
    return screen;
}

- (CGFloat) scale {
#if TARGET_OS_WATCH
    return WKInterfaceDevice.currentDevice.screenScale;
#else
    return 2; // visionOS renders at a fixed 2x
#endif
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
