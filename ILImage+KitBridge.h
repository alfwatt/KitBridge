#import <KitBridge/KitBridgeDefines.h>

@interface ILImage (KitBridge)

- (ILImage*) inverted;
- (ILImage*) templateTintedWithColor:(ILColor*) tint;

@end
