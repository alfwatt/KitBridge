#import "ILFont+KitBridge.h"

@implementation ILFont (KitBridge)

#ifdef IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize
{
    return [UIFont monospacedDigitSystemFontOfSize:fontSize weight:UIFontWeightRegular];
}
#endif

@end
