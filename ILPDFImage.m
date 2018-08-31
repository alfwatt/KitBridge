#import "ILPDFImage.h"
#import "ILScreen+KitBridge.h"
#import <PDFKit/PDFKit.h>

@interface ILPDFImage ()
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
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width * screenScale, size.height * screenScale, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(ctx, screenScale, screenScale);

    CGPDFPageRef renderPage = CGPDFDocumentGetPage(document, page);
    CGContextDrawPDFPage(ctx, renderPage);
    CGImageRef image = CGBitmapContextCreateImage(ctx);
    pdfImage = [[UIImage alloc] initWithCGImage:image scale:screenScale orientation:UIImageOrientationUp];
    
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

@end
