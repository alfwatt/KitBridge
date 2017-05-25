#import "ILBezierPath+KitBridge.h"
#import "KitBridgeFunctions.h"

NSString* CGPathElementDescription(const CGPathElement *element)
{
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

void CGPathEnumerationCallback(void *info, const CGPathElement *element)
{
    NSMutableString* pathDescription = (__bridge NSMutableString*) info;
    [pathDescription appendString:CGPathElementDescription(element)];

}

NSString* ILCGPathDescription(CGPathRef path)
{
    NSMutableString* pathDescription = [NSMutableString new]; // create a new string
    [pathDescription appendFormat:@"<CGPathRef: %p\n", path];
    [pathDescription appendFormat:@"  Bounds: %@\n", ILStringFromCGRect(CGPathGetPathBoundingBox(path))];
    [pathDescription appendFormat:@"  Control Point Bounds: %@\n", ILStringFromCGRect(CGPathGetBoundingBox(path))];
    CGPathApply(path, (__bridge void * _Nullable)(pathDescription), CGPathEnumerationCallback);
    return pathDescription;
}

#pragma mark -

@implementation ILBezierPath (KitBridge)

#ifdef IL_APP_KIT
#pragma mark - UIBezierPath methods

- (void) addLineToPoint:(CGPoint)point
{
    [self lineToPoint:point];
}

- (void) addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    [self appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}

/*
 https://stackoverflow.com/a/1956021
 https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html#//apple_ref/doc/uid/TP40003290-CH206-SW2
*/
- (CGPathRef) CGPath
{
    CGPathRef immutablePath = NULL;
    NSUInteger numElements = [self elementCount];
    
    if (numElements > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        BOOL didClosePath = YES;
        
        for (NSUInteger index = 0; index < numElements; index++) {
            NSPoint points[3] = {0, 0, 0, 0, 0, 0};
            
            switch ([self elementAtIndex:index associatedPoints:points]) {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
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
    
    return immutablePath;
}

#endif

@end
