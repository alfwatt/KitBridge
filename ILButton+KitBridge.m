#import "ILButton+KitBridge.h"

@implementation ILButton (KitBridge)

#if IL_UI_KIT
- (NSString*) title
{
    return self.titleLabel.text;
}

- (void) setTitle:(NSString*) title
{
    self.titleLabel.text = title;
}
#endif

@end
