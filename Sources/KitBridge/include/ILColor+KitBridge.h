#import <CoreImage/CoreImage.h>

#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

@interface ILColor (KitBridge)
/// If this is color is from a catalog, the name or a css hex string describing the color
@property(nonatomic, readonly) NSString* colorName;
/// a css hex string
@property(nonatomic, readonly) NSString* hexColor;
/// a css rgb string
@property(nonatomic, readonly) NSString* rgbColor;
/// a css rgba string
@property(nonatomic, readonly) NSString* rgbaColor;
/// a CSS hsl string
@property(nonatomic, readonly) NSString* hslColor;
/// a CSS hsla string
@property(nonatomic, readonly) NSString* hslaColor;
/// the desaturated color wheel compliment of this color
@property(nonatomic, readonly) ILColor* complementaryColor;
/// a desaturated contrasting color with the same hue
@property(nonatomic, readonly) ILColor* contrastingColor;
#if IL_APP_KIT
@property(nonatomic, readonly) CIColor* CIColor;
#endif

// MARK: - CSS Color Constructors

/// @param cssColor a string in [CSS format](https://www.w3.org/TR/css-color-4/) e.g.:
///     #FFF
///     #FFFFFF
///     rgb(255,255,255)
///     rgba(255,255,255,1.0)
///     hsv(360,100%,100%)
///     hsva(360,100%,100%,1.0)
/// @returns the ILColor for the cssColor provided, or nil if the cssColor cannot be parsed
///
/// TODO: implement lab(), lch(), gray(), device-cymk() & c. from:
/// TODO: NSError in-paramter for parsing feedback to the calling app
+ (ILColor*) colorWithCSSColor:(NSString*) cssColor;

#if IL_UI_KIT

// MARK: - Text Colors
@property (class, strong, readonly) ILColor* textColor;
@property (class, strong, readonly) ILColor* textBackgroundColor;
@property (class, strong, readonly) ILColor* textInsertionPointColor;
@property (class, strong, readonly) ILColor* selectedTextColor;
@property (class, strong, readonly) ILColor* selectedTextBackgroundColor;
@property (class, strong, readonly) ILColor* keyboardFocusIndicatorColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedTextBackgroundColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedTextColor;

// MARK: - Content Colors
@property (class, strong, readonly) ILColor* linkColor;
@property (class, strong, readonly) ILColor* separatorColor;
@property (class, strong, readonly) ILColor* selectedContentBackgroundColor;
@property (class, strong, readonly) ILColor* unemphasizedSelectedContentBackgroundColor;

// MARK: - Menu Colors
@property (class, strong, readonly) ILColor* selectedMenuItemTextColor;

// MARK: - Table Colors
@property (class, strong, readonly) ILColor* gridColor;
@property (class, strong, readonly) ILColor* headerTextColor;
@property (class, strong, readonly) NSArray<ILColor* > *alternatingContentBackgroundColors;

// MARK: - Control Colors
@property (class, strong, readonly) ILColor* controlAccentColor;
@property (class, strong, readonly) ILColor* controlColor;
@property (class, strong, readonly) ILColor* controlBackgroundColor;
@property (class, strong, readonly) ILColor* controlTextColor;
@property (class, strong, readonly) ILColor* disabledControlTextColor;
@property (class, strong, readonly) ILColor* selectedControlColor;
@property (class, strong, readonly) ILColor* selectedControlTextColor;
@property (class, strong, readonly) ILColor* alternateSelectedControlTextColor;
@property (class, strong, readonly) ILColor* scrubberTexturedBackgroundColor;

// MARK: - Window Colors
@property (class, strong, readonly) ILColor* windowBackgroundColor;
@property (class, strong, readonly) ILColor* windowFrameTextColor;
@property (class, strong, readonly) ILColor* underPageBackgroundColor;

// MARK: - Highlights and Shadows
@property (class, strong, readonly) ILColor* findHighlightColor;
@property (class, strong, readonly) ILColor* highlightColor;
@property (class, strong, readonly) ILColor* shadowColor;

#else // IL_APP_KIT

// MARK: - Tint Color
@property(class, nonatomic, readonly) ILColor* tintColor; // NSColor.currentControlTint

// MARK: - Standard Content Background Colors
@property(class, nonatomic, readonly) ILColor* systemBackgroundColor; // NSColor.systemFillColor?
@property(class, nonatomic, readonly) ILColor* secondarySystemBackgroundColor; // NSColor.secondarySystemFillColor?
@property(class, nonatomic, readonly) ILColor* tertiarySystemBackgroundColor; // NSColor.tertiarySystemFillColor?

// MARK: - Grouped content background colors
@property(class, nonatomic, readonly) ILColor* systemGroupedBackgroundColor; // NSColor.systemFillColor?
@property(class, nonatomic, readonly) ILColor* secondarySystemGroupedBackgroundColor; // NSColor.secondarySystemFillColor?
@property(class, nonatomic, readonly) ILColor* tertiarySystemGroupedBackgroundColor; // NSColor.tertiarySystemFillColor?

// MARK: - Separator colors
@property(class, nonatomic, readonly) ILColor* opaqueSeparatorColor;

// MARK: - Nonadaptable colors
@property(class, nonatomic, readonly) ILColor* darkTextColor;
@property(class, nonatomic, readonly) ILColor* lightTextColor;

// MARK: - Adaptable Colors
@property (class, strong, readonly) ILColor* systemGray2Color;
@property (class, strong, readonly) ILColor* systemGray3Color;
@property (class, strong, readonly) ILColor* systemGray4Color;
@property (class, strong, readonly) ILColor* systemGray5Color;
@property (class, strong, readonly) ILColor* systemGray6Color;
#endif

@end
