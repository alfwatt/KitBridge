#include <TargetConditionals.h>
#if !TARGET_OS_WATCH
#import "ILStoryboard+KitBridge.h"

@implementation ILStoryboard (KitBridge)

#if IL_APP_KIT
- (__kindof ILViewController*) instantiateInitialViewController {
    return [self instantiateInitialController];
}

- (__kindof ILViewController *)instantiateViewControllerWithIdentifier:(NSString*) identifier {
    return [self instantiateControllerWithIdentifier:identifier];
}
#endif

@end
#endif // !TARGET_OS_WATCH
