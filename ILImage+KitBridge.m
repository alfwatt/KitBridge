#import <KitBridge/KitBridge.h>
#import "ILImage+KitBridge.h"

@implementation ILImage (KitBridge)

- (ILImage*) inverted
{
    CIImage* ciImage = [[CIImage alloc] initWithData:[self TIFFRepresentation]];
    if ([self isFlipped]) {
        CGRect cgRect = [ciImage extent];
        CGAffineTransform transform;
        transform = CGAffineTransformMakeTranslation(0.0,cgRect.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        ciImage = [ciImage imageByApplyingTransform:transform];
    }
    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage* output = [filter valueForKey:@"outputImage"];
    [output drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOver fraction:1.0];

#ifdef IL_APP_KIT
    return [[NSImage alloc] initWithCGImage:output.CGImage size:self.size];
#else
    return [UIImage imageWithCGImage:output];
#endif
}

- (ILImage*) templateTintedWithColor:(ILColor*) tint
{
#ifdef IL_APP_KIT
    NSSize size = [self size];
    NSRect imageBounds = NSMakeRect(0, 0, size.width, size.height);
    NSImage *copiedImage = [self copy];
    
    [copiedImage lockFocus];
    [tint set];
    NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
    [copiedImage unlockFocus];
    
    return copiedImage;
#else
    UIImage* tinted = [self copy];
    tinted.tintColor = tint;
    tinted.renderingMode = UIImageRenderingModeAlwaysTemplate;
    return tinted;
#endif
}

@end
