#import <UIKit/UIKit.h>
#import "NotificationPermissionsManager.h"
#import "AppDelegate.h"

int FakeSettingsAppMain(int argc, char * argv[]) {
    NSString *bundleIdentifier = NSProcessInfo.processInfo.environment[@"bundleIdentifier"];
    NSString *displayName = NSProcessInfo.processInfo.environment[@"displayName"];
    NSString *status = NSProcessInfo.processInfo.environment[@"status"];
    NSString *runApplication = NSProcessInfo.processInfo.environment[@"runApplication"];
    
    if (bundleIdentifier && displayName && status) {
        NotificationPermissionsManager *notificationPermissionsManager = [[NotificationPermissionsManager alloc] initWithBundleIdentifier:bundleIdentifier displayName:displayName];
        
        [notificationPermissionsManager setNotificationPermissionsStatus:status];
    }
    
    if ([runApplication isEqualToString:@"true"]) {
        // UIApplicationMain is necessary, because XCUI waits app to be idle. If app exits then test fails.
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    
    return 0;
}
