#import <CoreImage/CoreImage.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "KitBridgeDefines.h"
#import "ILPDFImage.h"
#import "ILImage+KitBridge.h"
#import "ILScreen+KitBridge.h"

@implementation ILImage (KitBridge)

#if IL_APP_KIT
+ (ILImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(NSObject*)traitCollection {
    return [bundle imageForResource:name];
}

+ (ILImage*) systemImageNamed:(NSString*) name {
    return [self imageWithSystemSymbolName:name accessibilityDescription:NSLocalizedString(name, @"system image name")];
}

// MARK: -

- (ILImage*) initWithCGImage:(CGImageRef) imageRef {
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)); // ???: Apply Scale Factor for retina?
    return [self initWithCGImage:imageRef size:imageSize];
}

- (CGImageRef) CGImage {
    NSRect imageRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    return [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
}

#endif

- (ILImage*) inverted {
#if IL_APP_KIT
    CIImage* ciImage = [CIImage.alloc initWithData:self.TIFFRepresentation];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:@"inputImage"];
    CIImage* output = [filter valueForKey:@"outputImage"];
    [output drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([output extent]) operation:NSCompositingOperationSourceOver fraction:1.0];

    return [ILImage.alloc initWithCGImage:output.CGImage size:self.size];
#else
    return nil;
#endif
}

#if IL_APP_KIT
- (ILImage*) imageWithTintColor:(ILColor*) tint {
    CGSize size = [self size];
    CGRect imageBounds = CGRectMake(0, 0, size.width, size.height);
    ILImage *tintedImage = [self copy];

    [tintedImage setTemplate:NO];
    [tintedImage lockFocus];
    [tint setFill];
    NSRectFillUsingOperation(imageBounds, NSCompositingOperationSourceAtop);
    [tintedImage unlockFocus];

    return tintedImage;
}
#endif

/*! https://github.com/mbcharbonneau/UIImage-Categories/blob/master/UIImage%2BResize.m */
- (ILImage*) croppedImage:(CGRect)bounds {
    CGFloat scale = ILScreen.mainScreen.scale;
    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledBounds);
#if IL_APP_KIT
    ILImage *croppedImage = [NSImage.alloc initWithCGImage:imageRef size:NSZeroSize];
#elif IL_UI_KIT
    ILImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
#endif
    CGImageRelease(imageRef);
    return croppedImage;
}

/*! https://github.com/mbcharbonneau/UIImage-Categories/blob/master/UIImage%2BResize.m */
- (ILImage*) resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed  = NO;

#if IL_UI_KIT
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        drawTransposed = YES;
        break;
        default:
        drawTransposed = NO;
    }
#endif

    CGAffineTransform transform = [self transformForOrientation:newSize];

    return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}

- (ILImage*) resizedImage:(CGSize)newSize {
    ILImage* resized = nil;

    if ([self respondsToSelector:@selector(resizedImage:withScale:)]) {
        resized = [(id<ILImageResizing>)self resizedImage:newSize withScale:ILScreen.mainScreen.scale];
    }
    else {
        resized = [self resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    }

    return resized;
}

- (ILImage*) resizedImageToScale:(CGFloat) scale {
    CGSize scaled = CGSizeMake((self.size.width * scale), (self.size.height * scale));
    return [self resizedImage:scaled];
}

- (ILImage*) resizedImageToWidth:(CGFloat) width {
    CGFloat scale = (width / self.size.width);
    return [self resizedImageToScale:scale];
}

- (BOOL)writePNGToURL:(NSURL*)URL outputSize:(CGSize)outputSizePx alphaChannel:(BOOL)alpha error:(NSError*__autoreleasing*)error {
    BOOL result = NO;
#if IL_APP_KIT
    ILImage* scalingImage = [ILImage imageWithSize:self.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [self drawAtPoint:NSMakePoint(0.0, 0.0) fromRect:dstRect operation:NSCompositingOperationSourceOver fraction:1.0];
        return YES;
    }];
    CGRect proposedRect = CGRectMake(0.0, 0.0, outputSizePx.width, outputSizePx.height);
    unsigned components = 4;
    unsigned bitsPerComponent = 8;
    unsigned bytesPerRow = proposedRect.size.width * (components * (bitsPerComponent / BYTE_SIZE));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef cgContext = CGBitmapContextCreate(NULL,
        proposedRect.size.width, proposedRect.size.height,
        bitsPerComponent, bytesPerRow, colorSpace, (enum CGBitmapInfo) (alpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithCGContext:cgContext flipped:NO];
    NSDictionary* hints = @{(id)kCGImagePropertyHasAlpha: @(alpha)};
    CGImageRef cgImage = [scalingImage CGImageForProposedRect:&proposedRect context:context hints:hints];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)URL, (__bridge CFStringRef)UTTypePNG.identifier, 1, NULL);
    CFDictionaryRef imageOptions = CFBridgingRetain(hints);
    CGImageDestinationAddImage(destination, cgImage, imageOptions);

    if (CGImageDestinationFinalize(destination)) {
        result = NO;
    }
    else {
        NSError* writeError = [NSError errorWithDomain:@"SSWPNGAdditionsErrorDomain" code:10 userInfo:@{
            NSLocalizedDescriptionKey: @"Error writing PNG image",
            @"ILImage": self,
            @"PNG URL": URL,
            @"Output Size": NSStringFromSize(outputSizePx),
            @"Alpha Channel": (alpha ? @"Yes" : @"No")

        }];
        if (*error != nil && writeError) {
            *error = writeError;
        }
    }

exit:

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(cgContext);
    CFRelease(destination);
    CFRelease(imageOptions);
#elif IL_UI_KIT
    result = [UIImagePNGRepresentation(self) writeToURL:URL atomically:YES];
#endif
    return result;
}

- (BOOL) isEqualToImage:(ILImage*)other {
    BOOL isEqual = NO;
    if (CGSizeEqualToSize(self.size, other.size)) { // check for size, could check other attributes as well
        CGDataProviderRef selfProvider = CGImageGetDataProvider(self.CGImage);
        CGDataProviderRef otherProvider = CGImageGetDataProvider(other.CGImage);
        NSData* selfData = CFBridgingRelease(CGDataProviderCopyData(selfProvider));
        NSData* otherData = CFBridgingRelease(CGDataProviderCopyData(otherProvider));
        isEqual = [selfData isEqualToData:otherData];
        CFBridgingRelease(selfProvider);
        CFBridgingRelease(otherProvider);
    }

    return isEqual;
}

// MARK: - Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (ILImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
#if IL_UI_KIT
    CGFloat scale = MAX(1.0f, self.scale);
#else
    CGFloat scale = 1.0f;
#endif
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;

    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(
        NULL,
        newRect.size.width,
        newRect.size.height,
        8, /* bits per channel */
        (newRect.size.width * 4), /* 4 channels per pixel * numPixels/row */
        colorSpace,
        (enum CGBitmapInfo) kCGImageAlphaPremultipliedLast
    );
    CGColorSpaceRelease(colorSpace);
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, (transpose ? transposedRect : newRect), imageRef);

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
#if IL_APP_KIT
    ILImage* newImage = [NSImage.alloc initWithCGImage:newImageRef size:NSZeroSize];
#elif IL_UI_KIT
    ILImage* newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
#endif

    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);

    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;

#if IL_UI_KIT
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;

        default:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        default:
            break;
    }
#endif

    return transform;
}

// MARK: - NSObject

- (NSString*) debugDescription {
    return [NSString stringWithFormat:@"<%@: %p> cgimage: \n%@\ndata: \n%@",
            NSStringFromClass(self.class), self,
//            NSStringFromCGSize(self.size), self.scale,
            self.CGImage, CGImageGetDataProvider(self.CGImage)];
}

@end
