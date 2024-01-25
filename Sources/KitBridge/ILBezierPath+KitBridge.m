#import "ILBezierPath+KitBridge.h"
#import "KitBridgeFunctions.h"

#pragma mark Functions

NSString* ILCGPathElementDescription(const CGPathElement *element) {
    NSString* description = nil;
    
    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            CGPoint point = element ->points[0];
            description = [NSString stringWithFormat:@"%f %f %@", point.x, point.y, @"moveto"];
            break;
        }
        case kCGPathElementAddLineToPoint: {
            CGPoint point = element ->points[0];
            description = [NSString stringWithFormat:@"%f %f %@", point.x, point.y, @"lineto"];
            break;
        }
        case kCGPathElementAddQuadCurveToPoint: {
            CGPoint point1 = element->points[0];
            CGPoint point2 = element->points[1];
            description = [NSString stringWithFormat:@"%f %f %f %f %@", point1.x, point1.y, point2.x, point2.y, @"quadcurveto"];
            break;
        }
        case kCGPathElementAddCurveToPoint: {
            CGPoint point1 = element->points[0];
            CGPoint point2 = element->points[1];
            CGPoint point3 = element->points[2];
            description = [NSString stringWithFormat:@"%f %f %f %f %f %f %@", point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, @"curveto"];
            break;
        }
        case kCGPathElementCloseSubpath: {
            description = @"closepath";
            break;
        }
    }

    return description;
}

void ILCGPathDescriptionCallback(void* info, const CGPathElement* element) {
    NSMutableString* pathDescription = (__bridge NSMutableString*) info;
    [pathDescription appendString:ILCGPathElementDescription(element)];

}

void ILCGPathCopyCallback(void* info, const CGPathElement* element) {
    ILBezierPath* path = (__bridge ILBezierPath*) info;
    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            [path moveToPoint:element->points[0]];
            break;
        }
        case kCGPathElementAddLineToPoint: {
            [path addLineToPoint:element->points[0]];
            break;
        }
        case kCGPathElementAddQuadCurveToPoint: {
            [path addQuadCurveToPoint:element->points[0] controlPoint:element->points[1]];
            break;
        }
        case kCGPathElementAddCurveToPoint: {
            [path addCurveToPoint:element->points[0] controlPoint1:element->points[1] controlPoint2:element->points[2]];
            break;
        }
        case kCGPathElementCloseSubpath: {
            [path closePath];
            break;
        }
    }
}


NSString* ILCGPathDescription(CGPathRef path) {
    NSMutableString* pathDescription = NSMutableString.new; // create a new string
    [pathDescription appendFormat:@"<CGPathRef: %p\n", path];
    [pathDescription appendFormat:@"  Bounds: %@\n", ILStringFromCGRect(CGPathGetPathBoundingBox(path))];
    [pathDescription appendFormat:@"  Control Point Bounds: %@\n", ILStringFromCGRect(CGPathGetBoundingBox(path))];
    CGPathApply(path, (__bridge void * _Nullable)pathDescription, ILCGPathDescriptionCallback);
    return pathDescription;
}

void ILCGPathElementCountCallback(void *info, const CGPathElement *element) {
    NSInteger elementCount = *(NSInteger*)info;
    *(NSInteger*)info = elementCount + 1; // ++ upset the static analyzer/compiler
}

NSInteger ILCGPathElementCount(CGPathRef path) {
    NSInteger elementCount = 0;
    CGPathApply(path, &elementCount, ILCGPathElementCountCallback);
    return elementCount;
}

void ILCGPathElementBlockCallback(void *info, const CGPathElement *element) {
    ILBezierPathEnumerator block = (__bridge ILBezierPathEnumerator) info;
    block(element);
}

// MARK: -

@implementation ILBezierPath (KitBridge)

#if IL_APP_KIT
// MARK: - UIBezierPath
// MARK: - Factory Methods

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius {
    return [NSBezierPath bezierPathWithRoundedRect:(NSRect)rect xRadius:cornerRadius yRadius:cornerRadius];
}

+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(ILRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    // XXX Assumes ILRectCornerAllCorners
    return [NSBezierPath bezierPathWithRoundedRect:(NSRect)rect xRadius:cornerRadii.width yRadius:cornerRadii.height];
}

+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    NSBezierPath* path = NSBezierPath.new;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return path;
}

+ (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath {
    NSBezierPath* path = NSBezierPath.new;
    CGPathApply(CGPath, (__bridge void * _Nullable)path, ILCGPathCopyCallback);
    return path;
}

// MARK: - Properties

/*
 
 https://stackoverflow.com/a/1956021
 
 https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html#//apple_ref/doc/uid/TP40003290-CH206-SW2

NSBezierPath.GCPath is Avaiable in macos 14 and later
 
*/
- (CGPathRef) ILCGPath {
    if (@available(macOS 14.0, *)) {
        return self.CGPath;
    } else {
        CGPathRef immutablePath = NULL;
        NSUInteger numElements = [self elementCount];
        
        if (numElements > 0) {
            CGMutablePathRef path = CGPathCreateMutable();
            BOOL didClosePath = YES;
            
            for (NSUInteger index = 0; index < numElements; index++) {
                NSPoint points[3] = {NSZeroPoint, NSZeroPoint, NSZeroPoint};
                NSBezierPathElement pathElement = [self elementAtIndex:index associatedPoints:points];
                
                switch (pathElement) {
                    case NSBezierPathElementMoveTo:
                        CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                        break;
                        
                    case NSBezierPathElementLineTo:
                        CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                        didClosePath = NO;
                        break;
                        
                    case NSBezierPathElementCubicCurveTo:
                        CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                              points[1].x, points[1].y,
                                              points[2].x, points[2].y);
                        didClosePath = NO;
                        break;
                        
                    case NSBezierPathElementQuadraticCurveTo:
                        CGPathAddQuadCurveToPoint(path, NULL, points[0].x, points[0].y,
                                                  points[1].x, points[1].y);
                        didClosePath = NO;
                        break;
                        
                    case NSBezierPathElementClosePath:
                        CGPathCloseSubpath(path);
                        didClosePath = YES;
                        break;
                }
            }
            
            // Be sure the path is closed or Quartz may not do valid hit detection.
            if (!didClosePath) {
                CGPathCloseSubpath(path);
            }
            
            immutablePath = CGPathCreateCopy(path);
            CGPathRelease(path);
        }
        
        if (immutablePath) {
            CFAutorelease(immutablePath);
        }
        
        return immutablePath;
    }
}

// MARK: - Path Construction

- (void) addLineToPoint:(CGPoint)point {
    [self lineToPoint:point];
}

- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2 {
    [self curveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
}

- (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint {
    [self curveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint];
}

// everyting is backwards!
- (void) addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    [self appendBezierPathWithArcWithCenter:center
        radius:radius
        startAngle:ILRadiansToDegrees(startAngle)
        endAngle:ILRadiansToDegrees(endAngle)
        clockwise:!clockwise];
}

// MARK: - Appending Paths

- (void)appendPath:(ILBezierPath *)bezierPath {
    // TODO
}

#else // IL_UI_KIT
// MARK: - NSBezierPath
// MARK: - Properties

- (CGPathRef) ILCGPath {
    return self.CGPath;
}

- (NSInteger) elementCount {
    return ILCGPathElementCount(self.CGPath);
}

#endif

// MARK: - ILBezierPath Additions
// MARK: - Enumerating Paths

- (void)enumeratePathWithBlock:(ILBezierPathEnumerator) enumerator {
    CGPathApply(self.CGPath, (__bridge void * _Nullable)(enumerator), ILCGPathElementBlockCallback);
}

@end
