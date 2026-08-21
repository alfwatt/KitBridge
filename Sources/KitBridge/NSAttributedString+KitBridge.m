#import "include/NSAttributedString+KitBridge.h"
#if __has_include(<KitBridge/ILFont+KitBridge.h>)
#import <KitBridge/ILFont+KitBridge.h>
#import <KitBridge/ILColor+KitBridge.h>
#else
#import "include/ILFont+KitBridge.h"
#import "include/ILColor+KitBridge.h"
#endif

@implementation NSAttributedString (KitBridge)

+ (NSAttributedString*) attributedString:(NSString*) string {
    return [NSAttributedString.alloc initWithString:string];
}

+ (NSAttributedString*) attributedString:(NSString*) string withFont:(ILFont*) font {
    NSDictionary* attrs = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: ILColor.textColor
    };
    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*)string withLink:(NSURL*) url {
    NSDictionary* attrs = @{
        NSFontAttributeName: [ILFont systemFontOfSize:ILFont.defaultFontSize],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: ILColor.textColor,
        NSLinkAttributeName: url.absoluteString
    };

    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url andAttributes:(NSDictionary*) attrs {
    NSMutableDictionary* mutableAttrs = attrs.mutableCopy;
    mutableAttrs[NSLinkAttributeName] = url.absoluteString;
    mutableAttrs[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);

    return [NSAttributedString.alloc initWithString:string attributes:mutableAttrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs {
    return [NSAttributedString.alloc initWithString:string attributes:attrs];
}

#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach {
    NSTextAttachment* attachment = NSTextAttachment.new;
    [attachment setAttachmentCell:attach];
    return [NSAttributedString attributedStringWithAttachment:attachment];
}
#endif

// MARK: -

- (NSArray<NSString*>*) rangesForAttribute:(NSString*) attribute value:(nullable id) attrValue {
    NSMutableArray<NSString*>* ranges = NSMutableArray.new;

    [self enumerateAttribute:attribute inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id _Nullable value, NSRange range, BOOL* _Nonnull stop) {
        if (value) {
            if (attrValue) {
                if ([value isEqual:attrValue]) {
                    [ranges addObject:NSStringFromRange(range)];
                }
            }
            else {
                [ranges addObject:NSStringFromRange(range)];
            }
        }
    }];

    return ranges;
}

@end

// MARK: -

@implementation NSMutableAttributedString (KitBridge)

- (void) replaceAttribute:(NSString*) attribute value:(nullable id) value newValue:(nullable id) newValue {
    [self enumerateAttribute:attribute inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id _Nullable obj, NSRange range, BOOL* _Nonnull stop) {
        if (!value || [obj isEqual:value]) {
            [self removeAttribute:attribute range:range];
            if (newValue) {
                [self addAttribute:attribute value:newValue range:range];
            }
        }
    }];
}

@end
