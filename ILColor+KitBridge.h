#import <KitBridge/KitBridgeDefines.h>
#import <CoreImage/CoreImage.h>

@interface ILColor (KitBridge)
@property(nonatomic, readonly) CIColor *CIColor;

#ifdef IL_UI_KIT
+ (ILColor*) disabledControlTextColor;
#endif

@end
