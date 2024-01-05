#import "ILProgressView+KitBridge.h"

@implementation ILProgressView (KitBridge)

#if IL_APP_KIT
- (void)startAnimating {
    [self startAnimation:self];
}

- (void)stopAnimating {
    [self stopAnimation:self];
}
#endif

@end
