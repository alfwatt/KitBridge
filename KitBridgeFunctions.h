#ifndef KitBridgeFunctions_h
#define KitBridgeFunctions_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*! @return the largest square centered in the provided rectangle */
inline CGRect ILRectSquareInRect(CGRect rect);

/*! @return the points in vector form */
inline CGVector ILVectorFromPointToPoint(CGPoint from, CGPoint to);

/*! @return the length of the vector using the Pythagorean theorem */
inline CGFloat ILVectorLength(CGVector delta);

/*! @return the angle of the vector in radians */
inline CGFloat ILVectorRadians(CGVector delta);

/*! @return the center point of the rect */
inline CGPoint ILPointCenteredInRect(CGRect rect);

/*! @brief project a point the provided distance along the vector provided */
inline CGPoint ILPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance);

/*! @brief NSString from rect in the style of NSStringFromCGRect in UIKit */
inline NSString* ILStringFromCGRect(CGRect rect);

/*! @brief check to see if a point is 'normal' and neither value is NaN or Infinite */
inline BOOL ILIsNormalPoint(CGPoint point);

/*! @brief check to see if a size is 'normal' and neither value is NaN or Infinite */
inline BOOL ILIsNormalSize(CGSize size);

/*! @brief check to see if a rect has a 'normal' origin and size and neither value is NaN or Infinite */
inline BOOL ILIsNormalRect(CGRect rect);

/*! @brief Converts degrees to radians. */
inline CGFloat ILDegreesToRadians(CGFloat angleDegrees); // (angleDegrees * M_PI / 180.0)

/*! @brief Converts radians to degrees. */
inline CGFloat ILRadiansToDegrees(CGFloat angleRadians); // (angleRadians * 180.0 / M_PI)

#endif /* KitBridgeFunctions_h */
