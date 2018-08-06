#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VisibilityChecker : NSObject

+ (double)percentElementVisibleOnScreen:(UIView *)element;

@end
