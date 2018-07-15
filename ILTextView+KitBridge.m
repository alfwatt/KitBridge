#import "ILTextView+KitBridge.h"

@implementation ILTextView (KitBridge)

#if IL_APP_KIT
- (NSString*) text
{
    return self.stringValue;
}

- (void) setText:(NSString*) text
{
    self.stringValue = text;
}
#endif

@end