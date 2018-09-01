#import <KitBridge/KitBridgeDefines.h>

@protocol ILImageResizing

- (ILImage*) resizedImage:(CGSize)newSize withScale:(CGFloat) scale;

@end

#pragma mark -

@interface ILImage (KitBridge)

- (ILImage*) inverted;
- (ILImage*) templateTintedWithColor:(ILColor*) tint;
- (ILImage*) croppedImage:(CGRect)bounds;
- (ILImage*) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (ILImage*) resizedImage:(CGSize)newSize;

#if IL_APP_KIT
+ (ILImage *)imageNamed:(NSString*)name inBundle:(NSBundle*)bundle compatibleWithTraitCollection:(NSObject*)traitCollection;

- (CGImageRef) CGImage;
#endif

@end
