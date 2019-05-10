#import <Foundation/Foundation.h>

typedef NSString ErrorString;

@interface NotificationPermissionsManager : NSObject

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier displayName:(NSString *)displayName;
- (ErrorString *)setNotificationPermissionsStatus:(NSString *)status timeout:(NSTimeInterval)timeout;

@end
