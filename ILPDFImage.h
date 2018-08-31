#import <UIKit/UIKit.h>

/*!

UIImage subclass which can be initilized with a PDF image and
can produce UIImages rendered at various sizes from the PDF source.

*/
@interface ILPDFImage : UIImage

#pragma mark - UIImage Overrides

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;

@end
