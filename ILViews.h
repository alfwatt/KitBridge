#import <Foundation/Foundation.h>

/*! @brief adds common init and update methods to all views in the SparkKit */
@protocol ILViews <NSObject>

/*! @brief run from initWithFrame: or initWithCoder: to initilzize the view */
- (void) initView;

/*! @brief have the view query it's data source and redraw itself */
- (void) updateView;

@end
