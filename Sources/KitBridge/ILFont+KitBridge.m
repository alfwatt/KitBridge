#import "ILFont+KitBridge.h"

#if IL_APP_KIT
#define ILFontDescriptorClassMask NSFontDescriptorClassMask
#define ILFontDescriptorTraitBold NSFontDescriptorTraitBold
#define ILFontDescriptorTraitMonoSpace NSFontDescriptorTraitMonoSpace
#define ILFontDescriptorClassSansSerif NSFontDescriptorClassSansSerif
#define ILFontDescriptorClassModernSerifs NSFontDescriptorClassModernSerifs
#define ILFontWeightTrait NSFontWeightTrait
#define ILFontWeightThin NSFontWeightThin
#define ILFontWeightLight NSFontWeightLight
/* TODO aliases for all the Desriptors, Traits, etc */
#else
#define ILFontDescriptorClassMask UIFontDescriptorClassMask
#define ILFontDescriptorTraitBold UIFontDescriptorTraitBold
#define ILFontDescriptorTraitMonoSpace UIFontDescriptorTraitMonoSpace
#define ILFontDescriptorClassSansSerif UIFontDescriptorClassSansSerif
#define ILFontDescriptorClassModernSerifs UIFontDescriptorClassModernSerifs
#define ILFontWeightTrait UIFontWeightTrait
#define ILFontWeightThin UIFontWeightThin
#define ILFontWeightLight UIFontWeightLight
/* TODO move these to KitBridgeDefines and replicate in KitBridgeAliases.swift */
#endif

NSString* const ILFontBoldFace = @"ILFontBoldFace";
NSString* const ILFontLightFace = @"ILFontLightFace";
NSString* const ILFontFixedFace = @"ILFontFixedFace";
NSString* const ILFontRegularFace = @"ILFontRegularFace";
NSString* const ILFontSerifFace = @"ILFontSerifFace";

NSString* const ILFontSize = @"ILFontSize";

@implementation ILFont (KitBridge)

+ (ILFont*)applicationFontFace:(NSString*)fontFace {
    NSString* fontName = NSBundle.mainBundle.infoDictionary[fontFace];
    return [ILFont fontWithName:fontName size:ILFont.applicationFontSize];
}

+ (ILFont*)applicationFontForSystemFont:(ILFont*)systemFont {
    NSString* fontName = systemFont.fontName;
    CGFloat fontWeight = [systemFont.fontDescriptor.fontAttributes[ILFontWeightTrait] doubleValue];
    
    if (systemFont.fontDescriptor.symbolicTraits & ILFontDescriptorTraitBold) {
        fontName = NSBundle.mainBundle.infoDictionary[ILFontBoldFace];
    }
    else if ([fontName rangeOfString:@"-Light"].location != NSNotFound || fontWeight == ILFontWeightThin || fontWeight == ILFontWeightLight) {
        fontName = NSBundle.mainBundle.infoDictionary[ILFontLightFace];
    }
    else if (systemFont.fontDescriptor.symbolicTraits & ILFontDescriptorTraitMonoSpace) {
        fontName = NSBundle.mainBundle.infoDictionary[ILFontFixedFace];
    }
    else if ((systemFont.fontDescriptor.symbolicTraits | ILFontDescriptorClassMask) & ILFontDescriptorClassSansSerif) {
        fontName = NSBundle.mainBundle.infoDictionary[ILFontRegularFace];
    }
    else if ((systemFont.fontDescriptor.symbolicTraits | ILFontDescriptorClassMask) & ILFontDescriptorClassModernSerifs) {
        fontName = NSBundle.mainBundle.infoDictionary[ILFontSerifFace];
    }
    
    ILFont* replacmentFont = [ILFont fontWithName:fontName size:systemFont.pointSize];
    if (!replacmentFont) {
        NSLog(@"WARNING no replacment for system font: %@ -> %@", systemFont, fontName);
        replacmentFont = systemFont;
    }
    
    return replacmentFont;
}

+ (CGFloat) defaultFontSize {
    return ILFont.applicationFontSize;
}

+ (CGFloat) applicationFontSize {
#if !TARGET_OS_TV
    CGFloat applicationFontSize = ILFont.systemFontSize;
#else
    CGFloat applicationFontSize = 36;
#endif

    if (NSUserDefaults.standardUserDefaults.dictionaryRepresentation[ILFontSize]) {
        applicationFontSize = [NSUserDefaults.standardUserDefaults.dictionaryRepresentation[ILFontSize] doubleValue];
    }
    else if (NSBundle.mainBundle.infoDictionary[ILFontSize]) {
        applicationFontSize = [NSBundle.mainBundle.infoDictionary[ILFontSize] doubleValue];
    }
    
    return applicationFontSize;
}

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize {
    return [UIFont monospacedDigitSystemFontOfSize:fontSize weight:UIFontWeightRegular];
}
#endif

@end

// MARK: -

@implementation ILView (KitBridge_ILFont)

- (void)replaceSystemFonts {
    if ([self isKindOfClass:ILTextView.class]) {
        ILTextView* text = (ILTextView*)self;
        text.font = [ILFont applicationFontForSystemFont:text.font];
    }
    else if ([self isKindOfClass:[ILLabel class]]) {
        ILLabel* label = (ILLabel*)self;
        label.font = [ILFont applicationFontForSystemFont:label.font];
    }
    
    for (ILView* subview in self.subviews) {
        [subview replaceSystemFonts];
    }
}

@end
