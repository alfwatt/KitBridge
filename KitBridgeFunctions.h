#ifndef KitBridgeFunctions_h
#define KitBridgeFunctions_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*! @return the largest square centered in the provided rectangle */
CGRect ILRectSquareInRect(CGRect rect);

/*! @return the points in vector form */
CGVector ILVectorFromPointToPoint(CGPoint from, CGPoint to);

/*! @return the length of the vector using the pythagorian therom */
CGFloat ILVectorLength(CGVector delta);

/*! @return the angle of the vector in radians */
CGFloat ILVectorRadians(CGVector delta);

/*! @return the center point of the rect */
CGPoint ILPointCenteredInRect(CGRect rect);

/*! @brief project a point the provided distance along the vector provided */
CGPoint ILPointOnLineToPointAtDistance(CGPoint from, CGPoint to, CGFloat distance);

/*! @brief NSString from rect in the style of NSStringFromCGRect in UIKit */
NSString* ILStringFromCGRect(CGRect rect);

#endif /* KitBridgeFunctions_h */
