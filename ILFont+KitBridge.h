#import <KitBridge/KitBridgeDefines.h>

@interface ILFont (KitBridge)
#ifdef IL_UI_KIT
+ (ILFont*) userFixedPitchFontOfSize:(CGFloat) fontSize;
#endif

@end
