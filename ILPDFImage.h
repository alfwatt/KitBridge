#import <KitBridge/KitBridgeDefines.h>

#if IL_UI_KIT && !TARGET_OS_TVOS
#import <KitBridge/ILImage+KitBridge.h>

/*!

@brief ILImage subclass which can be initilized with a PDF image and
can produce UIImages rendered at various sizes from the PDF source.

*/
@interface ILPDFImage : ILImage <ILImageResizing>

#pragma mark - UIImage Overrides

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;
- (instancetype)initWithData:(NSData *)data;

@end
#endif
