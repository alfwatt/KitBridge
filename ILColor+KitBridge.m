#import "ILColor+KitBridge.h"

@implementation ILColor (KitBridge)

#pragma mark - Properties

- (CIColor*) CIColor
{
    return [CIColor colorWithCGColor:self.CGColor];
}

- (ILColor*) complementaryColor
{
    ILColor* complementary = nil;
    
    if ([self isEqual:[ILColor whiteColor]]
        || [self isEqual:[ILColor lightGrayColor]]) {
        complementary = [ILColor blackColor];
    }
    else if ([self isEqual:[ILColor blackColor]]
             || [self isEqual:[ILColor grayColor]]) {
        complementary = [ILColor whiteColor];
    }
    else if ([self isEqual:[ILColor blueColor]]) {
        ILColor* orange = [ILColor orangeColor];
        CGFloat hue, saturation, brightness, alpha = 0;
        [orange getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        complementary = [ILColor colorWithHue:hue saturation:(saturation * 0.7) brightness:brightness alpha:alpha];
    }
    else { // return a hue-wise complement at the same luminance
        CGFloat hue, saturation, brightness, alpha, compliment = 0;
        [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        compliment = (hue > 0.5 ? (hue - 0.5) : (hue + 0.5));
        CGFloat desaturated = (saturation * 0.7);
        CGFloat luminance = ((brightness >= 0.6) ? 0.2 : 0.95); // adjust brightness for better contrast
        complementary = [ILColor colorWithHue:compliment saturation:desaturated brightness:luminance alpha:alpha];
    }

    return complementary;
}

- (ILColor*) contrastingColor
{
    ILColor* contrasting = nil;
    if ([self isEqual:[ILColor whiteColor]]
     || [self isEqual:[ILColor lightGrayColor]]) {
        contrasting = [ILColor blackColor];
    }
    else if ([self isEqual:[ILColor blackColor]]
          || [self isEqual:[ILColor grayColor]]) {
        contrasting = [ILColor whiteColor];
    }
    else {
        CGFloat hue, saturation, brightness, alpha;
        [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        CGFloat desaturated = (saturation * 0.5);
        CGFloat luminance = ((brightness >= 0.6) ? 0.2 : 0.95); // adjust brightness for better contrast
        contrasting = [ILColor colorWithHue:hue saturation:desaturated brightness:luminance alpha:alpha];
    }
    return contrasting;
}

#ifdef IL_UI_KIT
+ (ILColor*) disabledControlTextColor
{
    return [ILColor grayColor];
}
#endif

@end
