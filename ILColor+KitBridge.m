#import "ILColor+KitBridge.h"

@implementation ILColor (KitBridge)

+ (ILColor*) colorWithCSSColor:(NSString*) cssColor
{
    ILColor* color = nil;
    
    if ([cssColor rangeOfString:@"#"].location == 0) {
        unsigned red, blue, green;
        if (cssColor.length == 4) { // #123
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(1, 1)]] scanHexInt:&red];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(2, 1)]] scanHexInt:&blue];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(3, 1)]] scanHexInt:&green];
            color = [ILColor colorWithRed:((CGFloat) red / 255.0f) green:((CGFloat) green / 255.0f) blue:((CGFloat) blue / 255.0f) alpha:1.0];
        }
        else if (cssColor.length == 7) { // #123456
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(1, 2)]] scanHexInt:&red];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(3, 2)]] scanHexInt:&blue];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(5, 2)]] scanHexInt:&green];
            color = [ILColor colorWithRed:((CGFloat) red / 255.0f) green:((CGFloat) green / 255.0f) blue:((CGFloat) blue / 255.0f) alpha:1.0];
        }
        else {
            NSLog(@"WARNING Invalid CSS Hex: %@", cssColor);
        }
    }
    else if ([cssColor rangeOfString:@"rgba"].location == 0) {
        int red, blue, green;
        float alpha;
        NSScanner* colorScanner = [NSScanner scannerWithString:cssColor];
        [colorScanner scanString:@"rgba" intoString:nil];
        [colorScanner scanString:@"(" intoString:nil];
        [colorScanner scanInt:&red];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&green];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&blue];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanFloat:&alpha];
        
        color = [ILColor colorWithRed:((CGFloat) red / 255.0f) green:((CGFloat) green / 255.0f) blue:((CGFloat) blue / 255.0f) alpha:alpha];
    }
    else if ([cssColor rangeOfString:@"rgb"].location == 0) {
        int red, blue, green;
        NSScanner* colorScanner = [NSScanner scannerWithString:cssColor];
        [colorScanner scanString:@"rgb" intoString:nil];
        [colorScanner scanString:@"(" intoString:nil];
        [colorScanner scanInt:&red];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&green];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&blue];

        color = [ILColor colorWithRed:((CGFloat) red / 255.0f) green:((CGFloat) green / 255.0f) blue:((CGFloat) blue / 255.0f) alpha:1.0];
    }
    else if ([cssColor rangeOfString:@"hsla"].location == 0) {
        int hue, sat, val;
        float alpha;
        NSScanner* colorScanner = [NSScanner scannerWithString:cssColor];
        colorScanner.charactersToBeSkipped = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        colorScanner.caseSensitive = NO;
        [colorScanner scanString:@"hsla" intoString:nil];
        [colorScanner scanString:@"(" intoString:nil];
        [colorScanner scanInt:&hue];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&sat];
        [colorScanner scanString:@"%" intoString:nil];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&val];
        [colorScanner scanString:@"%" intoString:nil];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanFloat:&alpha];
        
        color = [ILColor colorWithHue:((CGFloat) hue / 360.0f) saturation:((CGFloat) sat / 100.0f) brightness:((CGFloat) val / 100.0f) alpha:alpha];
    }
    else if ([cssColor rangeOfString:@"hsl"].location == 0) {
        int hue, sat, val;
        NSScanner* colorScanner = [NSScanner scannerWithString:cssColor];
        colorScanner.charactersToBeSkipped = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        colorScanner.caseSensitive = NO;
        [colorScanner scanString:@"hsl" intoString:nil];
        [colorScanner scanString:@"(" intoString:nil];
        [colorScanner scanInt:&hue];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&sat];
        [colorScanner scanString:@"%" intoString:nil];
        [colorScanner scanString:@"," intoString:nil];
        [colorScanner scanInt:&val];
        
        color = [ILColor colorWithHue:((CGFloat) hue / 360.0f) saturation:((CGFloat) sat / 100.0f) brightness:((CGFloat) val / 100.0f) alpha:1.0];
    }
    else {
        NSLog(@"WARNING Invalid CSS Color: %@", cssColor);
    }
    
    return color;
}

#pragma mark - Properties

- (NSString*) colorName
{
    NSString* nameString = nil;
#if IL_APP_KIT
    ILColor* namedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    if (namedColor) {
        nameString = namedColor.localizedColorNameComponent;
    }
    else
#endif
    {
        nameString = self.hexColor;
    }
    
    return nameString;
}

- (NSString*) hexColor
{
    NSString* hexString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#else
    ILColor* rgbColor = self;
#endif
    if (rgbColor) {
        CGFloat red, green, blue;
        [rgbColor getRed:&red green:&green blue:&blue alpha:nil];
        hexString = [NSString stringWithFormat:@"#%02X%02X%02X",
            (int) (0xFF * red),
            (int) (0xFF * green),
            (int) (0xFF * blue)];
    }
    return hexString;
}

- (NSString*) rgbColor
{
    NSString* rgbaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#else
    ILColor* rgbColor = self;
#endif

    if (rgbColor) {
        CGFloat red, green, blue;
        [rgbColor getRed:&red green:&green blue:&blue alpha:nil];
        rgbaString = [NSString stringWithFormat:@"rgba(%d,%d,%d)", // 999 shades of gray
                      (int) (255 * red),
                      (int) (255 * green),
                      (int) (255 * blue)];
    }

    return rgbaString;
}

- (NSString*) rgbaColor
{
    NSString* rgbaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#else
    ILColor* rgbColor = self;
#endif

    if (rgbColor) {
        CGFloat red, green, blue, alpha;
        [rgbColor getRed:&red green:&green blue:&blue alpha:&alpha];
        rgbaString = [NSString stringWithFormat:@"rgba(%d,%d,%d,%.3f)", // 999 shades of gray
            (int) (255 * red),
            (int) (255 * green),
            (int) (255 * blue),
            alpha];
    }
    
    return rgbaString;
}

- (NSString*) hslColor
{
    NSString* hslaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#else
    ILColor* rgbColor = self;
#endif

    if (rgbColor) {
        CGFloat hue, sat, brt;
        [rgbColor getHue:&hue saturation:&sat brightness:&brt alpha:nil];
        hslaString = [NSString stringWithFormat:@"hsla(%d,%d%%,%d%%)",
            (int) (360 * hue),
            (int) (100 * sat),
            (int) (100 * brt)];
    }
    
    return hslaString;
}

- (NSString*) hslaColor
{
    NSString* hslaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#else
    ILColor* rgbColor = self;
#endif

    if (rgbColor) {
        CGFloat hue, sat, brt, alpha;
        [rgbColor getHue:&hue saturation:&sat brightness:&brt alpha:&alpha];
        hslaString = [NSString stringWithFormat:@"hsla(%d,%d%%,%d%%,%.3f)",
            (int) (360 * hue),
            (int) (100 * sat),
            (int) (100 * brt),
            alpha];
    }
    
    return hslaString;
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

#if IL_APP_KIT
- (CIColor*) CIColor
{
    return [CIColor colorWithCGColor:self.CGColor];
}
#endif


#pragma mark - Semantic Colors

#if IL_UI_KIT
+ (ILColor*) labelColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) secondaryLabelColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.498)"];
    }
    return color;
}

+ (ILColor*) tertiaryLabelColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.247)"];
    }
    return color;
}

+ (ILColor*) quaternaryLabelColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.098)"];
    }
    return color;
}

+ (ILColor*) linkColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(8, 79, 209, 1.000)"];
    }
    return color;
}

+ (ILColor*) placeholderTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.247)"];
    }
    return color;
}

+ (ILColor*) windowFrameTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) selectedMenuItemTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) alternateSelectedControlTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) headerTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) separatorColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.098)"];
    }
    return color;
}

+ (ILColor*) gridColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.098)"];
    }
    return color;
}

+ (ILColor*) windowBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(231, 231, 231, 1.000)"];
    }
    return color;
}

+ (ILColor*) underPageBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(131, 131, 131, 0.898)"];
    }
    return color;
}

+ (ILColor*) controlBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedContentBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(193, 58, 4, 1.000)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedContentBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(211, 211, 211, 1.000)"];
    }
    return color;
}

+ (NSArray<ILColor*>*) alternatingContentBackgroundColors
{
    static NSArray<ILColor*>* colors = nil;
    if (!colors) {
        colors = @[
           [ILColor controlBackgroundColor],
           [ILColor colorWithCSSColor:@"rgba(241, 242, 242, 1.000)"]
       ];
    }
    return colors;
}

+ (ILColor*) findHighlightColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 255, 10, 1.000)"];
    }
    return color;
}

+ (ILColor*) textColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}

+ (ILColor*) textBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedTextBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(250, 201, 159, 1.000)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedTextBackgroundColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(211, 211, 211, 1.000)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}


+ (ILColor*) controlColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) controlTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) selectedControlColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(250, 201, 159, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedControlTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) disabledControlTextColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.247)"];
    }
    return color;
}

+ (ILColor*) keyboardFocusIndicatorColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(228, 90, 8, 0.498)"];
    }
    return color;
}

+ (ILColor*) controlAccentColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(242, 108, 22, 1.000)"];
    }
    return color;
}


+ (ILColor*) highlightColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) shadowColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}


+ (ILColor*) systemRedColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(251, 32, 37, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemGreenColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(40, 199, 50, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemBlueColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(10, 95, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemOrangeColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(252, 129, 8, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemYellowColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(253, 194, 9, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemBrownColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(144, 113, 75, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemPinkColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(251, 12, 67, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemPurpleColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(69, 59, 204, 1.000)"];
    }
    return color;
}

+ (ILColor*) systemGrayColor
{
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(123, 123, 128, 1.000)"];
    }
    return color;
}
#endif

@end
