#import <KitBridge/KitBridgeDefines.h>
#import <CoreImage/CoreImage.h>

@interface ILColor (KitBridge)
@property(nonatomic, readonly) CIColor* CIColor;
@property(nonatomic, readonly) ILColor* complementaryColor;
@property(nonatomic, readonly) ILColor* contrastingColor;

#ifdef IL_UI_KIT
+ (ILColor*) disabledControlTextColor;
#endif

@end
