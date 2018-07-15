#import <KitBridge/KitBridgeDefines.h>

@interface ILFont (KitBridge)

+ (CGFloat) defaultFontSize;

#if IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end
