#import "ILTextView+KitBridge.h"

@implementation ILTextView (KitBridge)

#if IL_APP_KIT
- (NSString*) text
{
    return self.textStorage.string;
}

- (void) setText:(NSString*) text
{
    [self.textStorage replaceCharactersInRange:NSMakeRange(0,self.textStorage.length) withString:text];
}
#endif

@end

#pragma mark -

#if IL_APP_KIT
@implementation NSTextField (KitBridge)

- (NSString*) text
{
    return self.stringValue;
}

- (void) setText:(NSString*) text
{
    self.stringValue = text;
}

@end
#endif
