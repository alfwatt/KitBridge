#import "ILColor+KitBridge.h"

@implementation ILColor (KitBridge)

#ifdef IL_UI_KIT
+ (ILColor*) disabledControlTextColor
{
    return [ILColor grayColor];
}
#endif

#pragma mark - Properties

- (CIColor*) CIColor
{
    return [CIColor colorWithCGColor:self.CGColor];
}

@end
