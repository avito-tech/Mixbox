#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenshotUtil : NSObject

+ (UIImage *)grey_takeScreenshotAfterScreenUpdates:(BOOL)afterScreenUpdates;

@end

#endif
