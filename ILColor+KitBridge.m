#import "ILColor+KitBridge.h"

@implementation ILColor (KitBridge)

- (CIColor*) CIColor
{
    return [CIColor colorWithCGColor:self.CGColor];
}

@end
