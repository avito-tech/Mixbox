#import "AppDelegate.h"
#if SWIFT_PACKAGE
#import "../Permissions/NotificationPermissionsManager.h"
#else
#import "NotificationPermissionsManager.h"
#endif


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *viewController = [UIViewController new];
    viewController.view.frame = [UIScreen mainScreen].bounds;
    viewController.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *statusLabel = [UILabel new];
    statusLabel.frame = viewController.view.bounds;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.accessibilityIdentifier = @"fakeSettingsAppStatus";
    statusLabel.text = [self setPermissions] ?: @"OK";
    [viewController.view addSubview:statusLabel];
    
    // To not confuse people if they will be watching test execution.
    UILabel *appDescriptionLabel = [UILabel new];
    appDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    appDescriptionLabel.text = @"Fake settings app";
    appDescriptionLabel.font = [UIFont systemFontOfSize:10];
    appDescriptionLabel.frame = CGRectMake(
                                   0,
                                   viewController.view.bounds.size.height - 20,
                                   viewController.view.bounds.size.width,
                                   20
                                   );
    [viewController.view addSubview:appDescriptionLabel];
    
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
}

- (ErrorString *)setPermissions {
    NSString *bundleIdentifier = NSProcessInfo.processInfo.environment[@"bundleIdentifier"];
    NSString *displayName = NSProcessInfo.processInfo.environment[@"displayName"];
    NSString *status = NSProcessInfo.processInfo.environment[@"status"];
    NSString *timeout = NSProcessInfo.processInfo.environment[@"timeout"];
    
    if (!bundleIdentifier) {
        return @"bundleIdentifier is not set";
    }
    if (!displayName) {
        return @"displayName is not set";
    }
    if (!status) {
        return @"status is not set";
    }
    
    NotificationPermissionsManager *notificationPermissionsManager = [[NotificationPermissionsManager alloc] initWithBundleIdentifier:bundleIdentifier displayName:displayName];
    
    return [notificationPermissionsManager setNotificationPermissionsStatus:status timeout:[timeout doubleValue]];
}

@end
