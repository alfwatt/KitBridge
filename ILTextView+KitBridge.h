#import <KitBridge/KitBridgeDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface ILTextView (KitBridge)
#if IL_APP_KIT
@property(nonatomic, copy) NSString *text;
#endif

@end

#pragma mark -

#if IL_APP_KIT
@interface NSTextField (KitBridge)
@property(nonatomic, copy) NSString* text;

@end
#endif

NS_ASSUME_NONNULL_END
