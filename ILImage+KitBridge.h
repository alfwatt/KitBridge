#import <KitBridge/KitBridgeDefines.h>

@interface ILImage (KitBridge)

- (ILImage*) inverted;
- (ILImage*) templateTintedWithColor:(ILColor*) tint;
- (ILImage*) croppedImage:(CGRect)bounds;
- (ILImage*) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

#if IL_APP_KIT
+ (ILImage *)imageNamed:(NSString*)name inBundle:(NSBundle*)bundle compatibleWithTraitCollection:(NSObject*)traitCollection;

- (CGImageRef) CGImage;
#endif

@end
