#if SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

/*! @brief Font face name in info.plist to replace system fonts with ILFontDescriptorTraitBold */
extern NSString* const ILFontBoldFace;

/*! @brief Font face name in info.plist to replace system fonts with ILFontWeightThin, ILFontWeightLight or names ending in "-Light"  */
extern NSString* const ILFontLightFace;

/*! @brief Font face name in info.plist to replace system fixed-width fonts with */
extern NSString* const ILFontFixedFace;

/*! @brief Font face name in info.plist to replace system snas-serif fonts with */
extern NSString* const ILFontRegularFace;

/*! @brief Font face name in info.plist to replace system serif fonts with */
extern NSString* const ILFontSerifFace;

/*! @brief Font face size in info.plist and NSUserDefaults to use as the default */
extern NSString* const ILFontSize;

// MARK: -

@interface ILFont (KitBridge)

/*! @brief returns the font for the application specific font face in info.plist */
+ (ILFont*)applicationFontFace:(NSString*)fontFace;

/*! @biref returns the application specific font face coresponding the system font provided */
+ (ILFont*)applicationFontForSystemFont:(ILFont*)systemFont;

/*! @brief returns systemFontSize except on tvOS, where it returns '36' */
+ (CGFloat) defaultFontSize;

/*! @brief returns the application or user configured default font size, checking ILFontApplicationSize in the defaults database, then the info.plist */
+ (CGFloat) applicationFontSize;

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end

// MARK: -

@interface ILView (KitBridge_ILFont)

/*! @brief descends through the view tree and replaces system fonts with font faces defined in info.plist with the font face keys */
- (void)replaceSystemFonts;

@end
