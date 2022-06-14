#import "ILApplication+KitBridge.h"

@implementation ILApplication (KitBridge)

#if IL_APP_KIT
- (BOOL)openURL:(NSURL *)url {
    return [NSWorkspace.sharedWorkspace openURL:url];
}
#endif

@end
