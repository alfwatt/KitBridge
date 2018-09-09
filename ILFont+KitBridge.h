#import <KitBridge/KitBridgeDefines.h>

extern NSString* const ILFontLightFace;
extern NSString* const ILFontRegularFace;
extern NSString* const ILFontBoldFace;
extern NSString* const ILFontSerifFace;
extern NSString* const ILFontFixedFace;


@interface ILFont (KitBridge)

/*! @brief returns the font for the application specific font face in info.plist */
+ (ILFont*)applicationFontFace:(NSString*)fontFace;

/*! @biref returns the application specific font face coresponding the system font provided */
+ (ILFont*)applicationFontForSystemFont:(ILFont*)systemFont;

/*! @biref returns systemFontSize except on tvOS, where it returns '36' */
+ (CGFloat) defaultFontSize;

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end

#pragma mark -

@interface ILView (KitBridge_ILFont)

/*! @brief descends through the view tree and replaces system fonts with font faces defined in info.plist with the font face keys */
- (void)replaceSystemFonts;

@end
