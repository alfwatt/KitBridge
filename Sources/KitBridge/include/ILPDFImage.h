#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

#if IL_UI_KIT && !TARGET_OS_TV

#if __has_include(<KitBridge/ILImage+KitBridge.h>)
#import <KitBridge/ILImage+KitBridge.h>
#else
#import "ILImage+KitBridge.h"
#endif

/// ILImage subclass which can be initilized with a PDF image and can produce UIImages rendered at various sizes from the PDF source.
@interface ILPDFImage : ILImage <ILImageResizing>

// MARK: - UIImage Overrides

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;
- (instancetype)initWithData:(NSData *)data;

@end
#endif
