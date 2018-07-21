#import <KitBridge/KitBridgeDefines.h>

@interface ILImage (KitBridge)

- (ILImage*) inverted;
- (ILImage*) templateTintedWithColor:(ILColor*) tint;

#if IL_APP_KIT
+ (ILImage *)imageNamed:(NSString*)name inBundle:(NSBundle*)bundle compatibleWithTraitCollection:(NSObject*)traitCollection;
#endif

@end
