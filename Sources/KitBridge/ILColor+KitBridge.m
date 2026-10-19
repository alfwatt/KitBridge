#import "ILColor+KitBridge.h"

@implementation ILColor (KitBridge)

// TODO: use https://github.com/markiv/NSObject-AssociatedDictionary to add the cssColor string to the resuting color object
+ (ILColor*) colorWithCSSColor:(NSString*) cssColor {
    ILColor* color = nil;
    
    if ([cssColor rangeOfString:@"#"].location == 0) {
        unsigned red, green, blue;
        if (cssColor.length == 4) { // #123, each digit doubled: #112233
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(1, 1)]] scanHexInt:&red];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(2, 1)]] scanHexInt:&green];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(3, 1)]] scanHexInt:&blue];
            color = [ILColor colorWithRed:((CGFloat) red / 15.0f) green:((CGFloat) green / 15.0f) blue:((CGFloat) blue / 15.0f) alpha:1.0];
        }
        else if (cssColor.length == 7) { // #123456
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(1, 2)]] scanHexInt:&red];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(3, 2)]] scanHexInt:&green];
            [[NSScanner scannerWithString:[cssColor substringWithRange:NSMakeRange(5, 2)]] scanHexInt:&blue];
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

// MARK: - Properties

- (NSString*) colorName {
    NSString* nameString = nil;
#if IL_APP_KIT
    if (self.type == NSColorTypeCatalog) {
        nameString = self.localizedColorNameComponent;
    }
    else {
        nameString = self.hexColor;
    }
#else
        nameString = self.hexColor;
#endif
    
    return nameString;
}

- (NSString*) hexColor {
    NSString* hexString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
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

- (NSString*) rgbColor {
    NSString* rgbaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
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

- (NSString*) rgbaColor {
    NSString* rgbaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
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

- (NSString*) hslColor {
    NSString* hslaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
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

- (NSString*) hslaColor {
    NSString* hslaString = nil;
#if IL_APP_KIT
    ILColor* rgbColor = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
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

- (ILColor*) complementaryColor {
    ILColor* complementary = nil;
    
    if ([self isEqual:ILColor.whiteColor] || [self isEqual:ILColor.lightGrayColor]) {
        complementary = ILColor.blackColor;
    }
    else if ([self isEqual:ILColor.blackColor] || [self isEqual:ILColor.grayColor]) {
        complementary = ILColor.whiteColor;
    }
    else { // return a hue-wise complement at the same luminance
        CGFloat hue, saturation, brightness, alpha, compliment = 0;
        [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        compliment = (hue > 0.5) ? (hue - 0.5) : (hue + 0.5);
        CGFloat desaturated = (saturation * 0.7);
        CGFloat luminance = (brightness >= 0.6) ? 0.2 : 1.0; // adjust brightness for better contrast
        complementary = [ILColor colorWithHue:compliment saturation:desaturated brightness:luminance alpha:alpha];
    }
    
    return complementary;
}

- (ILColor*) contrastingColor {
    ILColor* contrasting = nil;

    if ([self isEqual:ILColor.whiteColor] || [self isEqual:ILColor.lightGrayColor]) {
        contrasting = ILColor.blackColor;
    }
    else if ([self isEqual:ILColor.blackColor] || [self isEqual:ILColor.grayColor]) {
        contrasting = ILColor.whiteColor;
    }
    else {
        CGFloat hue, saturation, brightness, alpha;
        [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        CGFloat desaturated = (saturation * 0.5);
        CGFloat luminance = (brightness >= 0.6) ? 0.2 : 0.8; // adjust brightness for better contrast
        contrasting = [ILColor colorWithHue:hue saturation:desaturated brightness:luminance alpha:alpha];
    }
    return contrasting;
}

#if IL_APP_KIT
- (CIColor*) CIColor {
    return [CIColor colorWithCGColor:self.CGColor];
}
#endif


// MARK: - Semantic Colors

#if IL_UI_KIT
// MARK: - Text Colors

+ (ILColor*) textColor {
    return UIColor.labelColor; // follows the appearance, like AppKit's, white in dark mode and on the TV
}

+ (ILColor*) textBackgroundColor {
#if TARGET_OS_TV
    return UIColor.clearColor; // tvOS draws its own backgrounds
#else
    return UIColor.systemBackgroundColor;
#endif
}

+ (ILColor*) textInsertionPointColor {
    return [ILColor textColor];
}

+ (ILColor*) selectedTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedTextBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(250, 201, 159, 1.000)"];
    }
    return color;
}

+ (ILColor*) keyboardFocusIndicatorColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(228, 90, 8, 0.498)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedTextBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(211, 211, 211, 1.000)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}

// MARK: - Content Colors

+ (ILColor*) linkColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(8, 79, 209, 1.000)"];
    }
    return color;
}

+ (ILColor*) separatorColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.098)"];
    }
    return color;
}

+ (ILColor*) selectedContentBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(193, 58, 4, 1.000)"];
    }
    return color;
}

+ (ILColor*) unemphasizedSelectedContentBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(211, 211, 211, 1.000)"];
    }
    return color;
}

// MARK: - Menu Colors

+ (ILColor*) selectedMenuItemTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

// MARK: - Table Colors

+ (ILColor*) gridColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.098)"];
    }
    return color;
}

+ (ILColor*) headerTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (NSArray<ILColor*>*) alternatingContentBackgroundColors {
    static NSArray<ILColor*>* colors = nil;
    if (!colors) {
        colors = @[
           [ILColor controlBackgroundColor],
           [ILColor colorWithCSSColor:@"rgba(241, 242, 242, 1.000)"]
       ];
    }
    return colors;
}

// MARK: - Control Colors

+ (ILColor*) controlAccentColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(242, 108, 22, 1.000)"];
    }
    return color;
}

+ (ILColor*) controlColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) controlBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) controlTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) disabledControlTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.247)"];
    }
    return color;
}

+ (ILColor*) selectedControlColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(250, 201, 159, 1.000)"];
    }
    return color;
}

+ (ILColor*) selectedControlTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) alternateSelectedControlTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"#666"]; // TODO: get the correct rgba
    }
    return color;
}

+ (ILColor*) scrubberTexturedBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"#666"]; // TODO: get the correct rbga
    }
    return color;
}

// MARK: - Window Colors

+ (ILColor*) windowBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(231, 231, 231, 1.000)"];
    }
    return color;
}

+ (ILColor*) windowFrameTextColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 0.847)"];
    }
    return color;
}

+ (ILColor*) underPageBackgroundColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(131, 131, 131, 0.898)"];
    }
    return color;
}

// MARK: - Highlights and Shadows

+ (ILColor*) findHighlightColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 255, 10, 1.000)"];
    }
    return color;
}


+ (ILColor*) highlightColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(255, 254, 254, 1.000)"];
    }
    return color;
}

+ (ILColor*) shadowColor {
    static ILColor* color = nil;
    if (!color) {
        color = [ILColor colorWithCSSColor:@"rgba(0, 0, 0, 1.000)"];
    }
    return color;
}
#else // UI_APP_KIT

// MARK: - Tint Color

+ (ILColor*) tintColor {
    return NSColor.controlAccentColor;
}

// MARK: - Standard Content Background Colors

+ (ILColor*) systemBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.systemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

+ (ILColor*) secondarySystemBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.secondarySystemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

+ (ILColor*) tertiarySystemBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.tertiarySystemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

// MARK: - Grouped content background colors

+ (ILColor*) systemGroupedBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.systemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

+ (ILColor*) secondarySystemGroupedBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.secondarySystemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

+ (ILColor*) tertiarySystemGroupedBackgroundColor {
    if (@available(macOS 14.0, *)) {
        return NSColor.tertiarySystemFillColor;
    } else {
        return NSColor.controlBackgroundColor;
    }
}

// MARK: - Separator colors

+ (ILColor*) opaqueSeparatorColor {
    return [NSColor.separatorColor colorWithAlphaComponent:1.0];
}

// MARK: - Nonadaptable colors

+ (ILColor*) darkTextColor {
    return NSColor.blackColor;
}

+ (ILColor*) lightTextColor {
    return NSColor.lightGrayColor;
}

// MARK: - Adaptable Colors

+ (ILColor*) systemGray2Color {
    return [NSColor colorWithDeviceWhite:0.45 alpha:1.0];
}

+ (ILColor*) systemGray3Color {
    return [NSColor colorWithDeviceWhite:0.40 alpha:1.0];
}

+ (ILColor*) systemGray4Color {
    return [NSColor colorWithDeviceWhite:0.35 alpha:1.0];
}

+ (ILColor*) systemGray5Color {
    return [NSColor colorWithDeviceWhite:0.30 alpha:1.0];
}

+ (ILColor*) systemGray6Color {
    return [NSColor colorWithDeviceWhite:0.25 alpha:1.0];
}

#endif

@end
