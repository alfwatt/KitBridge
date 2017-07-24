#include "KitBridgeFunctions.h"
#include "KitBridgeDefines.h"

#pragma mark - Math

CGFloat ILDegreesToRadians(CGFloat angleDegrees)
{
    return (angleDegrees * M_PI / 180.0);
}

CGFloat ILRadiansToDegrees(CGFloat angleRadians)
{
    return (angleRadians * 180.0 / M_PI);
}

#pragma mark - Geometry

CGRect ILRectSquareInRect(CGRect rect)
{
    CGFloat sideLength = fminf(rect.size.width, rect.size.height);
    CGFloat xOffset = rect.origin.x + ((rect.size.width - sideLength) * 2);
    CGFloat yOffset = rect.origin.y + ((rect.size.height - sideLength) * 2);
    CGRect square = CGRectIntegral(CGRectMake(xOffset, yOffset, sideLength, sideLength));
    
    return square;
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

BOOL ILIsNormalPoint(CGPoint point)
{
    return ((point.x == 0 || (fpclassify(point.x) == FP_NORMAL))
         || (point.y == 0 || (fpclassify(point.y) == FP_NORMAL)));
}

BOOL ILIsNormalSize(CGSize size)
{
    return ((size.width == 0  || (fpclassify(size.width) == FP_NORMAL))
         || (size.height == 0 || (fpclassify(size.height) == FP_NORMAL)));
}

BOOL ILIsNormalRect(CGRect rect)
{
    return ILIsNormalPoint(rect.origin) && ILIsNormalSize(rect.size);
}

#pragma mark - Foundation

NSString* ILStringFromCGRect(CGRect rect)
{
#ifdef IL_APP_KIT
    return NSStringFromRect(rect);
#elif IL_UI_KIT
    return NSStringFromCGRect(rect);
#endif
}
