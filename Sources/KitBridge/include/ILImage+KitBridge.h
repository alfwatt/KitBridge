#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

@protocol ILImageResizing

- (ILImage*) resizedImage:(CGSize)newSize withScale:(CGFloat) scale;

@end

// TODO: ILTraitCollection
// TODO: ILImageConfiguration

// MARK: -

@interface ILImage (KitBridge)

#if IL_APP_KIT
// MARK - Loading and caching images
+ (instancetype) imageNamed:(NSString*)name inBundle:(NSBundle*)bundle compatibleWithTraitCollection:(NSObject*)traitCollection;
// TODO: + (UIImage*) imageNamed:(NSString*)name inBundle:(NSBundle*)bundle withConfiguration:(UIImageConfiguration*)configuration;
// TODO: + (UIImage*) imageNamed:(NSString*)name inBundle:(NSBundle*)bundle variableValue:(double)value withConfiguration:(UIImageConfiguration*) configuration
// TODO: + (UIImage*) systemImageNamed:(NSString*)name withConfiguration:(UIImageConfiguration*) configuration;
// TODO: + (UIImage*) systemImageNamed:(NSString*)name variableValue:(double)value withConfiguration:(UIImageConfiguration*) configuration;
// TODO: + (UIImage*) systemImageNamed:(NSString*)name compatibleWithTraitCollection:(UITraitCollection*) traitCollection;
+ (instancetype) systemImageNamed:(NSString*) name;

// MARK: -

- (instancetype) initWithCGImage:(CGImageRef) imageRef;

- (CGImageRef) CGImage;

- (ILImage*) imageWithTintColor:(ILColor*) tint;
#endif

// MARK: ILImage

- (ILImage*) inverted;
- (ILImage*) croppedImage:(CGRect)bounds;
- (ILImage*) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (ILImage*) resizedImage:(CGSize)newSize;
- (ILImage*) resizedImageToScale:(CGFloat) scale;
- (ILImage*) resizedImageToWidth:(CGFloat) width;

/// Writes the image as a PNG to the file URL provided
/// http://stackoverflow.com/questions/17507170/how-to-save-png-file-from-nsimage-retina-issues
- (BOOL) writePNGToURL:(NSURL*)URL outputSize:(CGSize)outputSizePx alphaChannel:(BOOL)alpha error:(NSError*__autoreleasing*)error;

- (BOOL) isEqualToImage:(ILImage*)other;

@end
