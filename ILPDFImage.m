#import "ILPDFImage.h"
#import "ILImage+KitBridge.h"
#import "ILScreen+KitBridge.h"

#if IL_UI_KIT
#import <PDFKit/PDFKit.h>

@interface ILPDFImage()
@property(nonatomic,retain) id imageDocument;

@end

#pragma mark -

@implementation ILPDFImage

+ (UIImage*) imageWithPDFDocument:(CGPDFDocumentRef)document
    atPage:(NSUInteger)page
    atSize:(CGSize)size
    atScale:(CGFloat)screenScale
    preserveAspectRatio:(BOOL)preserveAspectRatio
{
    if (document == nil || CGSizeEqualToSize(size, CGSizeZero) || page == 0) {
        return nil;
    }
    
    UIImage *pdfImage = nil;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect contextRect = CGRectMake(0, 0, (size.width * screenScale), (size.height * screenScale));
    CGContextRef ctx = CGBitmapContextCreate(NULL, contextRect.size.width, contextRect.size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGPDFPageRef renderPage = CGPDFDocumentGetPage(document, page);
    CGRect pageRect = CGPDFPageGetBoxRect(renderPage, kCGPDFCropBox);
    CGAffineTransform renderTransform = CGAffineTransformIdentity;
    if (pageRect.size.width < contextRect.size.width) { // scale it up
        renderTransform = CGAffineTransformScale(
            renderTransform,
            (contextRect.size.width / pageRect.size.width),
            (contextRect.size.height / pageRect.size.height));
    }
    else { // scale down
        renderTransform = CGPDFPageGetDrawingTransform(renderPage, kCGPDFCropBox, contextRect, 0, preserveAspectRatio);
    }
    CGContextConcatCTM(ctx, renderTransform);
    CGContextDrawPDFPage(ctx, renderPage);
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    pdfImage = [UIImage imageWithCGImage:image scale:screenScale orientation:UIImageOrientationUp];
    
    CGImageRelease(image);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    return pdfImage;
}

#pragma mark - UIImage Overrides

- (instancetype) initWithPDFDocument:(CGPDFDocumentRef) document pageIndex:(NSUInteger) pageIndex scale:(CGFloat) imageScale
{
    CGPDFPageRef documentPage = CGPDFDocumentGetPage(document, pageIndex);
    CGRect pageBounds = CGPDFPageGetBoxRect(documentPage, kCGPDFCropBox);
    UIImage* renderedPage = [ILPDFImage imageWithPDFDocument:document atPage:pageIndex atSize:pageBounds.size atScale:imageScale preserveAspectRatio:YES];
    
    if (renderedPage && (self = [super initWithCGImage:renderedPage.CGImage])) {
        self.imageDocument = CFBridgingRelease(document);
    }
    
    return self;
}

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    if (!path) {
        return nil;
    }
    
    CGPDFDocumentRef fileDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path]);
    return [self initWithPDFDocument:fileDocument pageIndex:1 scale:UIScreen.mainScreen.scale];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGPDFDocumentRef fileDocument = CGPDFDocumentCreateWithProvider(dataProvider);
    return [self initWithPDFDocument:fileDocument pageIndex:1 scale:scale];
}

- (instancetype)initWithData:(NSData *)data
{
    return [self initWithData:data scale:UIScreen.mainScreen.scale];
}

#pragma mark - ILImage Overrides

- (ILImage*) resizedImage:(CGSize)newSize withScale:(CGFloat) scale
{
    return [ILPDFImage imageWithPDFDocument:(__bridge CGPDFDocumentRef)(self.imageDocument) atPage:1 atSize:newSize atScale:scale preserveAspectRatio:YES];
}
@end
#endif

