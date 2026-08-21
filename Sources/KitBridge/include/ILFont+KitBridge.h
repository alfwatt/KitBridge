#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

/// Font face name in info.plist to replace system fonts with ILFontDescriptorTraitBold
extern NSString* const ILFontBoldFace;

/// Font face name in info.plist to replace system fonts with ILFontWeightThin, ILFontWeightLight or names ending in "-Light"
extern NSString* const ILFontLightFace;

/// Font face name in info.plist to replace system fixed-width fonts with
extern NSString* const ILFontFixedFace;

/// Font face name in info.plist to replace system snas-serif fonts with
extern NSString* const ILFontRegularFace;

/// Font face name in info.plist to replace system serif fonts with
extern NSString* const ILFontSerifFace;

/// Font face size in info.plist and NSUserDefaults to use as the default
extern NSString* const ILFontSize;

// MARK: -

@interface ILFont (KitBridge)

/// returns the font for the application specific font face in info.plist
+ (ILFont*)applicationFontFace:(NSString*)fontFace;

/// returns the application specific font face coresponding the system font provided
+ (ILFont*)applicationFontForSystemFont:(ILFont*)systemFont;

/// returns systemFontSize except on tvOS, where it returns '36'
+ (CGFloat) defaultFontSize;

/// returns the application or user configured default font size, checking ILFontApplicationSize in the defaults database, then the info.plist
+ (CGFloat) applicationFontSize;

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end
