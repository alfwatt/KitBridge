#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif


NS_ASSUME_NONNULL_BEGIN

/// adds convenience methods to create attributed strings
@interface NSAttributedString (KitBridge)

+ (NSAttributedString*) attributedString:(NSString*) string;
+ (NSAttributedString*) attributedString:(NSString*) string withFont:(ILFont*) font;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url andAttributes:(NSDictionary*) attrs;
+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs;
#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach;
#endif

// MARK: -

/// @returns an array of character range strings which have the
/// @param attribute and
/// @param value provided if not nil
- (NSArray<NSString*>*) rangesForAttribute:(NSString*) attribute value:(nullable id) value;

@end

// MARK: -

@interface NSMutableAttributedString (KitBridge)

/// searches the string for ranges containg the
/// @param attribute provided, checking that the
/// @param value either matches, or is nil and replacing it with the
/// @param newValue provided
- (void) replaceAttribute:(NSString*) attribute value:(nullable id) value newValue:(nullable id) newValue;

@end

NS_ASSUME_NONNULL_END
