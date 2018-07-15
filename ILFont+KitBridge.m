#import "ILFont+KitBridge.h"

@implementation ILFont (KitBridge)

+ (CGFloat) defaultFontSize
{
#if !TARGET_OS_TV
    return [ILFont systemFontSize];
#else
    return 36;
#endif
}

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize
{
    return [UIFont monospacedDigitSystemFontOfSize:fontSize weight:UIFontWeightRegular];
}
#endif

@end
