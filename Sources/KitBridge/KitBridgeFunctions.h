#ifndef KitBridgeFunctions_h
#define KitBridgeFunctions_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// MARK: - Math

extern CGFloat const ILZeroAngleRadians; // 12 O'Clock position

/*! @brief Converts degrees to radians. */
CGFloat ILDegreesToRadians(CGFloat angleDegrees); // (angleDegrees * M_PI / 180.0)

/*! @brief Converts radians to degrees. */
CGFloat ILRadiansToDegrees(CGFloat angleRadians); // (angleRadians * 180.0 / M_PI)

/*! @brief Convertes percentage to radians. */
CGFloat ILPercentToRadians(CGFloat percent); // (percent * M_PI * 2)

// MARK: - Geometry

/*! @return the length of the vector using the Pythagorean theorem */
CGFloat ILVectorLength(CGVector delta);

/*! @return the angle of the vector in radians */
CGFloat ILVectorRadians(CGVector delta);

/*! @brief check to see if a point is 'normal' and neither value is NaN or Infinite */
BOOL ILIsNormalPoint(CGPoint point);

/*! @brief check to see if a size is 'normal' and neither value is NaN or Infinite */
BOOL ILIsNormalSize(CGSize size);

/*! @brief check to see if a rect has a 'normal' origin and size and neither value is NaN or Infinite */
BOOL ILIsNormalRect(CGRect rect);

/*! @return the points in vector form */
CGVector ILVectorFromPointToPoint(CGPoint from, CGPoint to);

/*! @return the largest square centered in the provided rectangle */
CGRect ILRectSquareInRect(CGRect rect);

/*! @return the center point of the rect */
CGPoint ILPointCenteredInRect(CGRect rect);

/*! @brief project a point the provided distance along the vector provided */
CGPoint ILPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance);

// MARK: - Foundation

/*! @brief NSString from rect in the style of NSStringFromCGRect in UIKit */
NSString* ILStringFromCGRect(CGRect rect);

#endif /* KitBridgeFunctions_h */
