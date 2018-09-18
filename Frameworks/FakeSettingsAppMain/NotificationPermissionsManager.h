#import <Foundation/Foundation.h>

@interface NotificationPermissionsManager : NSObject

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier displayName:(NSString *)displayName;
- (BOOL)setNotificationPermissionsStatus:(NSString *)status;

@end
