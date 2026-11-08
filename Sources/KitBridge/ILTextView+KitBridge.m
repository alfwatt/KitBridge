#include <TargetConditionals.h>
#if !TARGET_OS_WATCH
#import "ILTextView+KitBridge.h"

#if IL_APP_KIT
@implementation NSTextView (KitBridge)

- (NSString*) text {
    return self.textStorage.string;
}

- (void) setText:(NSString*) text {
    [self.textStorage replaceCharactersInRange:NSMakeRange(0,self.textStorage.length) withString:text];
}

@end

// MARK: -

@implementation NSTextField (KitBridge)

- (NSString*) text {
    return self.stringValue;
}

- (void) setText:(NSString*) text {
    self.stringValue = text;
}

@end
#endif

// MARK: -

@implementation NSTextStorage (KitBridge)

#if IL_UI_KIT
- (NSArray<NSTextStorage*>*) attributeRuns {
    NSMutableArray* attributeRuns = NSMutableArray.new;

    NSTextStorage* currentAttributeRun = NSTextStorage.new;
    NSDictionary* currentAttributes = nil;
    for (NSUInteger index = 0; index < self.length; index++) {
        NSDictionary* attributes = [self attributesAtIndex:index effectiveRange:nil];
        if (attributes != currentAttributes) {
            if (currentAttributeRun.length > 0) {
                [attributeRuns addObject:currentAttributeRun];
                currentAttributeRun = NSTextStorage.new;
            }
            currentAttributes = attributes;
        }
        [currentAttributeRun appendAttributedString:[self attributedSubstringFromRange:NSMakeRange(index, 1)]];
    }

    return attributeRuns;
}
#endif

@end
#endif // !TARGET_OS_WATCH
