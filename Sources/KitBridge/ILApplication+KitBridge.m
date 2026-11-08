#include <TargetConditionals.h>
#if !TARGET_OS_WATCH
#import "ILApplication+KitBridge.h"

@implementation ILApplication (KitBridge)

#if IL_APP_KIT
- (BOOL)openURL:(NSURL *)url {
    return [NSWorkspace.sharedWorkspace openURL:url];
}
#endif

#if IL_UI_KIT
- (BOOL) sendAction:(SEL) action to:(id) target from:(id)sender {
    BOOL sent = NO;

    if (action) {
        if (target) {
            sent = [UIApplication.sharedApplication sendAction:action to:target from:(sender ?: self) forEvent:nil];
        }
#if 0
        else { // no target, walk the responder chain of sender
            id next = [sender nextResponder];
            while (next) {
                if ([next respondsToSelector:action]) {
                    NSMethodSignature* signature = [next methodSignatureForSelector:action];
                    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.target = next;
                    [invocation setArgument:&sender atIndex:0];
                    [invocation retainArguments];
                    [invocation invoke]; // FIXME: EXC_BAD_ACCESS here despite retain above
                    break; // while
                }
                // UIApplication does not check it's delegate
                else if ([next isKindOfClass:UIApplication.class]) {
                    next = UIApplication.sharedApplication.delegate;
                }
                else if ([next isKindOfClass:UIResponder.class]){
                    next = [next nextResponder];
                }
                else {
                    next = nil;
                }
            }
        }
#endif
    }

    return sent;
}
#endif

@end
#endif // !TARGET_OS_WATCH
