#import <UIKit/UIKit.h>

#define iOS8_0_OR_ABOVE() ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
static const CGFloat kGREYMinimumVisibleAlpha = 0.01f;
static const NSUInteger kColorChannelsPerPixel = 4;
static const NSUInteger kBytesPerPixel = 4;

#define grey_ceil(x) ((CGFloat)ceil(x))
#define grey_floor(x) ((CGFloat)floor(x))

