#import <KitBridge/KitBridgeDefines.h>

@interface ILFont (KitBridge)

+ (CGFloat) defaultFontSize;

#ifdef IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end
