#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TODO: This checker misses blue channel, also it is not strict.
// A threshold for overlaying pixels is a kludge, it is based on rounding error.
@interface VisibilityChecker : NSObject

+ (double)percentElementVisibleOnScreen:(UIView *)element;

@end

#endif
