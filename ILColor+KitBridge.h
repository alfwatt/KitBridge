#import <KitBridge/KitBridgeDefines.h>
#import <CoreImage/CoreImage.h>

@interface ILColor (KitBridge)
@property(nonatomic, readonly) NSString* colorName;
@property(nonatomic, readonly) NSString* hexColor;
@property(nonatomic, readonly) NSString* rgbColor;
@property(nonatomic, readonly) NSString* rgbaColor;
@property(nonatomic, readonly) NSString* hslColor;
@property(nonatomic, readonly) NSString* hslaColor;
@property(nonatomic, readonly) ILColor* complementaryColor;
@property(nonatomic, readonly) ILColor* contrastingColor;
#if IL_APP_KIT
@property(nonatomic, readonly) CIColor* CIColor;
#endif

#pragma mark - CSS Color Constructors

/*! @brief color in CSS  format: e.g. #FFF, #FFFFFF, rgb(255,255,255), rgba(255,255,255,1.0), hsv(360,100%,100%), hsva(360,100%,100%,1.0) */
+ (ILColor*) colorWithCSSColor:(NSString*) cssColor;

#if IL_UI_KIT
#pragma mark - Semantic Colors

@property (class, strong, readonly) ILColor* labelColor;
@property (class, strong, readonly) ILColor* secondaryLabelColor;
@property (class, strong, readonly) ILColor* tertiaryLabelColor;
@property (class, strong, readonly) ILColor* quaternaryLabelColor;

@property (class, strong, readonly) ILColor* linkColor;
@property (class, strong, readonly) ILColor* placeholderTextColor;
@property (class, strong, readonly) ILColor* windowFrameTextColor;
@property (class, strong, readonly) ILColor* selectedMenuItemTextColor;
@property (class, strong, readonly) ILColor* alternateSelectedControlTextColor;
@property (class, strong, readonly) ILColor* headerTextColor;
@property (class, strong, readonly) ILColor* separatorColor;
@property (class, strong, readonly) ILColor* gridColor;

/* Background Colors */
@property (class, strong, readonly) ILColor* windowBackgroundColor;
@property (class, strong, readonly) ILColor* underPageBackgroundColor;
@property (class, strong, readonly) ILColor* controlBackgroundColor;
@property (class, strong, readonly) ILColor* selectedContentBackgroundColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedContentBackgroundColor;
@property (class, strong, readonly) NSArray<ILColor* > *alternatingContentBackgroundColors;
@property (class, strong, readonly) ILColor* findHighlightColor;

/* Text Colors */
@property (class, strong, readonly) ILColor* textColor;
@property (class, strong, readonly) ILColor* textBackgroundColor;
@property (class, strong, readonly) ILColor* selectedTextColor;
@property (class, strong, readonly) ILColor* selectedTextBackgroundColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedTextBackgroundColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedTextColor;

/* Control Colors */
@property (class, strong, readonly) ILColor* controlColor;
@property (class, strong, readonly) ILColor* controlTextColor;
@property (class, strong, readonly) ILColor* selectedControlColor;
@property (class, strong, readonly) ILColor* selectedControlTextColor;
@property (class, strong, readonly) ILColor* disabledControlTextColor;
@property (class, strong, readonly) ILColor* keyboardFocusIndicatorColor;
@property (class, strong, readonly) ILColor* controlAccentColor;

/* Hilight & Shadow */
@property (class, strong, readonly) ILColor* highlightColor;
@property (class, strong, readonly) ILColor* shadowColor;

/* System Colors */
@property (class, strong, readonly) ILColor* systemRedColor;
@property (class, strong, readonly) ILColor* systemGreenColor;
@property (class, strong, readonly) ILColor* systemBlueColor;
@property (class, strong, readonly) ILColor* systemOrangeColor;
@property (class, strong, readonly) ILColor* systemYellowColor;
@property (class, strong, readonly) ILColor* systemBrownColor;
@property (class, strong, readonly) ILColor* systemPinkColor;
@property (class, strong, readonly) ILColor* systemPurpleColor;
@property (class, strong, readonly) ILColor* systemGrayColor;
#endif

@end
