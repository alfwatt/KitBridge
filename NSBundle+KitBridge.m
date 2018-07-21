#import "NSBundle+KitBridge.h"

@implementation NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage *)imageForResource:(NSString*)name
{
    return [ILImage imageNamed:name inBundle:self compatibleWithTraitCollection:nil];
}
#endif

@end
