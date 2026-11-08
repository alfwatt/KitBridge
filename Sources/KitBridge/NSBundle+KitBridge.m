#import "NSBundle+KitBridge.h"
#import "ILPDFImage.h"

@implementation NSBundle (KitBridge)

#if IL_UI_KIT
- (ILImage*) imageForResource:(NSString*) name {
    ILImage* resourceImage = nil;

    if ([name.pathExtension isEqualToString:@"pdf"]) {
#if !TARGET_OS_TV && !TARGET_OS_WATCH
        NSString* imageResource = [self pathForResource:name.stringByDeletingPathExtension ofType:name.pathExtension];
        resourceImage = [ILPDFImage.alloc initWithContentsOfFile:imageResource];
#endif
    }
    else {
#if TARGET_OS_WATCH
        resourceImage = [UIImage imageNamed:name inBundle:self withConfiguration:nil]; // no trait collections on the watch
#else
        resourceImage = [UIImage imageNamed:name inBundle:self compatibleWithTraitCollection:nil];
#endif
    }

    return resourceImage;
}
#endif

@end
