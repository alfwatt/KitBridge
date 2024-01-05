#import "NSBundle+KitBridge.h"
#import "ILPDFImage.h"

@implementation NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage *)imageForResource:(NSString*)name {
    ILImage* resourceImage = nil;

#if !TARGET_OS_TV
    if ([name.pathExtension isEqualToString:@"pdf"]) {
        NSString* imageResource = [self pathForResource:name.stringByDeletingPathExtension ofType:name.pathExtension];
        resourceImage = [ILPDFImage.alloc initWithContentsOfFile:imageResource];
    }
    else
#endif
    {
        resourceImage = [UIImage imageNamed:name inBundle:self compatibleWithTraitCollection:nil];
    }

    return resourceImage;
}
#endif

@end
