#import <KitBridge/KitBridgeDefines.h>

/*! @header bridging header for UIBezierPath and NSBezierPath */

/*! @brief text description of a CGPathRef */
NSString* ILCGPathDescription(CGPathRef path);

/*! @brief count the number of elements in a CGPathRef */
NSInteger ILCGPathElementCount(CGPathRef path);

#ifdef IL_APP_KIT
// From UIBezierPath.h
typedef NS_OPTIONS(NSUInteger, ILRectCorner) {
    UIRectCornerTopLeft     = 1 << 0,
    UIRectCornerTopRight    = 1 << 1,
    UIRectCornerBottomLeft  = 1 << 2,
    UIRectCornerBottomRight = 1 << 3,
    UIRectCornerAllCorners  = ~0UL
};
#endif

typedef void(^ILBezierPathEnumerator)(const CGPathElement* element);

@interface ILBezierPath (KitBridge)

#ifdef IL_APP_KIT
#pragma mark - UIBezierPath methods
@property(nonatomic, readonly) CGPathRef CGPath;

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(ILRectCorner)corners cornerRadii:(CGSize)cornerRadii;

+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

+ (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;

#pragma mark - Path Construction

- (void)addLineToPoint:(CGPoint)point;

- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;

- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;

- (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

#pragma mark - Appending Paths

/*! @brief append a path to this one */
- (void)appendPath:(ILBezierPath*)bezierPath;

#else // IL_UI_KIT
@property (readonly) NSInteger elementCount;

#endif

#pragma mark - Enumerating Paths

/*! @brief the provided enumerator block is executed once for each point on the path */
- (void)enumeratePathWithBlock:(ILBezierPathEnumerator) enumerator;

@end
