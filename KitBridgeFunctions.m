#include "KitBridgeFunctions.h"
#include "KitBridgeDefines.h"

CGRect ILRectSquareInRect(CGRect rect)
{
    CGFloat sideLength = fminf(rect.size.width,rect.size.height);
    CGFloat xOffset = (rect.size.width-sideLength)/2;
    CGFloat yOffset = (rect.size.height-sideLength)/2;
    return CGRectIntegral(CGRectMake(xOffset,yOffset,sideLength,sideLength));
}

CGVector ILVectorFromPointToPoint(CGPoint from, CGPoint to)
{
    return CGVectorMake((from.x - to.x), (from.y - to.y));
}

CGFloat ILVectorLength(CGVector delta)
{
    return sqrt(fabs(delta.dx*delta.dx) + fabs(delta.dy*delta.dy));
}

CGFloat ILVectorRadians(CGVector delta)
{
    return atan2(delta.dx, delta.dy);
}

CGPoint ILPointCenteredInRect(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint ILPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance)
{
    CGVector lineVector = ILVectorFromPointToPoint(from, to);
    CGFloat lineDistance = ILVectorLength(lineVector);
    CGVector scaledVector = CGVectorMake(lineVector.dx / lineDistance, lineVector.dy / lineDistance);
    CGVector segmentVector = CGVectorMake( scaledVector.dx * distance, scaledVector.dy * distance);
    //  NSLog(@"ILPointOnLineToPointAtDistance: %@ -> %@ vector: %@ scaled: %@ segment: %@",
    //  NSStringFromCGPoint(from), NSStringFromCGPoint(to), NSStringFromCGVector(lineVector),
    //  NSStringFromCGVector(scaledVector), NSStringFromCGVector(segmentVector));
    return CGPointMake(from.x-segmentVector.dx, from.y-segmentVector.dy);
}

NSString* ILStringFromCGRect(CGRect rect)
{
#ifdef IL_APP_KIT
    return NSStringFromRect(rect);
#elif IL_UI_KIT
    return NSStringFromCGRect(rect);
#endif
}

BOOL ILIsNormalPoint(CGPoint point)
{
    return ((point.x == 0 || (fpclassify(point.x) == FP_NORMAL))
         || (point.y == 0 || (fpclassify(point.y) == FP_NORMAL)));
}
