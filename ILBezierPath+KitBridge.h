#import <KitBridge/KitBridge.h>

NSString* ILCGPathDescription(CGPathRef path);

@interface ILBezierPath (KitBridge)

#ifdef IL_APP_KIT
#pragma mark - UIBezierPath methods
@property(nonatomic, readonly) CGPathRef CGPath;

- (void)addLineToPoint:(CGPoint)point;

- (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

#endif

@end
