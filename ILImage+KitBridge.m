#import "KitBridgeDefines.h"
#import "ILImage+KitBridge.h"
#import <CoreImage/CoreImage.h>

@implementation ILImage (KitBridge)

- (ILImage*) inverted
{
#if IL_APP_KIT
    CIImage* ciImage = [[CIImage alloc] initWithData:[self TIFFRepresentation]];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage* output = [filter valueForKey:@"outputImage"];
    [output drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOver fraction:1.0];

    return [[ILImage alloc] initWithCGImage:output.CGImage size:self.size];
#else
    return nil;
#endif
}

- (ILImage*) templateTintedWithColor:(ILColor*) tint
{
    CGSize size = [self size];
    CGRect imageBounds = CGRectMake(0, 0, size.width, size.height);
    ILImage *tintedImage = nil;

#if IL_APP_KIT
    tintedImage = [self copy];
    [tintedImage setTemplate:NO];
    [tintedImage lockFocus];
    [tint setFill];
    NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
    [tintedImage unlockFocus];
#elif IL_UI_KIT
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, imageBounds, self.CGImage);
    CGContextSetFillColor(context, CGColorGetComponents(tint.CGColor));
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, imageBounds);

    tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#endif
    
    return tintedImage;
}

@end
