#import <KitBridge/KitBridge.h>
#import "ILImage+KitBridge.h"

@implementation ILImage (KitBridge)

- (ILImage*) inverted
{
#ifdef IL_APP_KIT
    CIImage* ciImage = [[CIImage alloc] initWithData:[self TIFFRepresentation]];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage* output = [filter valueForKey:@"outputImage"];
    [output drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOver fraction:1.0];

    return [[NSImage alloc] initWithCGImage:output.CGImage size:self.size];
#else
    return nil;
#endif
}

- (ILImage*) templateTintedWithColor:(ILColor*) tint
{
    CGSize size = [self size];
    CGRect imageBounds = CGRectMake(0, 0, size.width, size.height);
    ILImage *tintedImage = nil;

#ifdef IL_APP_KIT
    tintedImage = [self copy];
    [tint set];
    [tintedImage lockFocus];
    NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
    [tintedImage unlockFocus];
#else
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
