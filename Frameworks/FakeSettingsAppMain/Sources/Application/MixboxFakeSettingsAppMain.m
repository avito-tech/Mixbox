#import <UIKit/UIKit.h>
#import "NotificationPermissionsManager.h"
#import "AppDelegate.h"

int FakeSettingsAppMain(int argc, char * argv[]) {
    // UIApplicationMain is necessary, because XCUI waits app to be idle. If app exits then test fails.
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        @throw exception;
    }
}
