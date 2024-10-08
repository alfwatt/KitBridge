#ifdef SWIFT_PACKAGE
#import "KitBridgeDefines.h"
#else
#import <KitBridge/KitBridgeDefines.h>
#endif

#if IL_UI_KIT && !TARGET_OS_TV

#ifdef SWIFT_PACKAGE
#import "ILImage+KitBridge.h"
#else
#import <KitBridge/ILImage+KitBridge.h>
#endif // SWIFT_PACKAGE

/// ILImage subclass which can be initilized with a PDF image and can produce UIImages rendered at various sizes from the PDF source.
@interface ILPDFImage : ILImage <ILImageResizing>

// MARK: - UIImage Overrides

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;
- (instancetype)initWithData:(NSData *)data;

@end
#endif
