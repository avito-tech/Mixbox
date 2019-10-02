// За основу взято это:
// https://github.com/wix/detox/blob/master/detox/ios/DetoxHelper/DetoxHelper/Extension/SetNotificationPermissionOperation.m

@import UIKit;

#import "NotificationPermissionsManager.h"
#import "Entitlements.h"

// For debugging
#import "objc/runtime.h"

@interface NotificationPermissionsManager()

@property(nonatomic, copy) NSString *bundleIdentifier;
@property(nonatomic, copy) NSString *displayName;

@end

@protocol NotificationPermissionManager_declaration_for_suppressing_undeclared_selector_warning

- (void)setSectionInfo:(id)a0 forSectionID:(id)a1 withCompletion:(id)a2;

@end

@implementation NotificationPermissionsManager

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier
                             displayName:(NSString *)displayName {
    if (self = [super init]) {
        _bundleIdentifier = [bundleIdentifier copy];
        _displayName = [displayName copy];
    }
    return self;
}

- (ErrorString *)setNotificationPermissionsStatus:(NSString *)status timeout:(NSTimeInterval)timeout {
    __block ErrorString *error = nil;
    
    id sectionInfo = nil;
    
    if ([status isEqualToString:@"allowed"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:YES];
    } else if ([status isEqualToString:@"denied"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:NO];
    } else if ([status isEqualToString:@"notDetermined"]) {
        // TODO: notDetermined не работает. Попробовать сделать.
        sectionInfo = nil;
    } else {
        return [ErrorString stringWithFormat:@"status is not supported: %@", status];
    }
    
    dispatch_group_t dispatchGroup = dispatch_group_create();

    dispatch_group_enter(dispatchGroup);
    
    __block BOOL completionHandlerWasCalled = NO;

    [self setSectionInfo:sectionInfo completionHandler:^(NSError *localError) {
        error = [localError localizedDescription];
        completionHandlerWasCalled = YES;

        dispatch_group_leave(dispatchGroup);
    }];

    dispatch_group_wait(dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)));
    
    if (!completionHandlerWasCalled) {
        error = [ErrorString stringWithFormat:@"Timed out waiting for setSectionInfo completion (timeout = %@)", @(timeout)];
        
        CFStringRef entitlementKey = CFSTR("com.apple.bulletinboard.settings");
        NSString *nsStringEntitlementKey = (__bridge NSString *)entitlementKey;
        
        NSNumber *entitlementValue = (NSNumber *)getEntitlementValue(entitlementKey);
        
        if (!entitlementValue) {
            error = [ErrorString stringWithFormat:
                     @"%@, note that you probably forgot to set up entitlements for fake settings app in your Xcode project",
                     error
                     ];
        } else if (![entitlementValue respondsToSelector:@selector(boolValue)]) {
            error = [ErrorString stringWithFormat:
                     @"%@, note that %@ entitlement value doesn't respond to selector boolValue",
                     error,
                     nsStringEntitlementKey
                     ];
        } else if ([entitlementValue boolValue] == NO) {
            error = [ErrorString stringWithFormat:
                     @"%@, note that %@ entitlement value is NO, which is not expected, it is expected to be YES",
                     error,
                     nsStringEntitlementKey
                     ];
        }
    }
    
    return error;
}

- (NSBundle *)bulletinBoardFrameworkBundle {
    NSBundle *bundle = nil;
    
    Class sectionInfoClass = NSClassFromString(@"BBSectionInfo");
    if (sectionInfoClass == nil) {
        bundle = [NSBundle bundleWithURL:[self pathToBulletinBoardFramework]];
        [bundle load];
    } else {
        bundle = [NSBundle bundleForClass:sectionInfoClass];
    }
    
    return bundle;
}

- (NSURL *)pathToBulletinBoardFramework {
    // Paths seems to be right for every iOS version (9...11).
    //
    // /Library/Developer/CoreSimulator/Profiles/Runtimes/ ...
    //
    // iOS 9.3.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BulletinBoard.framework
    // iOS 9.3.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/UIKit.framework
    // iOS 11.2.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BulletinBoard.framework
    // iOS 11.2.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/UIKit.framework
    // iOS 11.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BulletinBoard.framework
    // iOS 11.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/UIKit.framework
    // iOS 10.3.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/BulletinBoard.framework
    // iOS 10.3.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/UIKit.framework
    
    NSBundle *foundationBundle = [NSBundle bundleForClass:[UIView class]];
    NSString *relativePathToBulletinBoardFramework = @"../../PrivateFrameworks/BulletinBoard.framework";
    
    NSURL *pathToBulletinBoardFramework = [foundationBundle.bundleURL URLByAppendingPathComponent:relativePathToBulletinBoardFramework];
    
    return [pathToBulletinBoardFramework URLByStandardizingPath];
}

- (void)setSectionInfo:(id)sectionInfo completionHandler:(void(^)(NSError* error))completionHandler {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    id settingsGateway = [[bundle classNamed:@"BBSettingsGateway"] new];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[settingsGateway methodSignatureForSelector:@selector(setSectionInfo:forSectionID:withCompletion:)]];
    
    [invocation setTarget:settingsGateway];
    [invocation setSelector:@selector(setSectionInfo:forSectionID:withCompletion:)];
    [invocation setArgument:&sectionInfo atIndex:2];
    [invocation setArgument:&_bundleIdentifier atIndex:3];
    
    [invocation retainArguments];
    
    [invocation setArgument:&completionHandler atIndex:4];
    [invocation invoke];
}

- (id)sectionInfoForForSettingNotificationsEnabled:(BOOL)enabled {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    
    id sectionInfo = [[bundle classNamed:@"BBSectionInfo"] new];
    
    [self printPropertiesOfInstance:sectionInfo];
    
    [sectionInfo setValue:@NO forKey:@"suppressFromSettings"];
    [sectionInfo setValue:@0 forKey:@"suppressedSettings"];
    [sectionInfo setValue:@0 forKey:@"sectionCategory"];
    [sectionInfo setValue:@0 forKey:@"subsectionPriority"];
    [sectionInfo setValue:@0 forKey:@"sectionType"];
    [sectionInfo setValue:@NO forKey:@"hideWeeApp"];
    [sectionInfo setValue:_displayName forKey:@"displayName"];
    [sectionInfo setValue:_bundleIdentifier forKey:@"sectionID"];
    
    switch ([self osMajorVersion]) {
        case 9:
        case 10:
        case 11:
        case 12: {
            [sectionInfo setValue:@NO forKey:@"displaysCriticalBulletins"];
            break;
        }
        case 13:
        default: {
            // New `spokenNotificationSetting` field appeared, but it is `long` and it is unclear how to set it up.
            break;
        }
    }
    
    id settings = [self sectionInfoSettingsForForSettingNotificationsEnabled:enabled];
    [sectionInfo setValue:settings forKey:@"sectionInfoSettings"];
    
    return sectionInfo;
}

- (id)sectionInfoSettingsForForSettingNotificationsEnabled:(BOOL)enabled {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    id settings = [[bundle classNamed:@"BBSectionInfoSettings"] new];
    
    [self printPropertiesOfInstance:settings];
    
    id alertType = @1;
    id allowsNotifications = @(enabled);
    id pushSettings = @63;
    id showsInLockScreen = @YES;
    id showsInNotificationCenter = @YES;
    id showsOnExternalDevices = @YES;
    id showsMessagePreview = @NO;
    id carPlaySetting = @NO;
    id contentPreviewSetting = @0;
    
    [settings setValue:alertType forKey:@"alertType"];
    [settings setValue:allowsNotifications forKey:@"allowsNotifications"];
    [settings setValue:pushSettings forKey:@"pushSettings"];
    [settings setValue:showsInLockScreen forKey:@"showsInLockScreen"];
    [settings setValue:showsInNotificationCenter forKey:@"showsInNotificationCenter"];
    [settings setValue:showsOnExternalDevices forKey:@"showsOnExternalDevices"];
    
    switch ([self osMajorVersion]) {
        case 9: {
            [settings setValue:showsMessagePreview forKey:@"showsMessagePreview"];
            break;
        }
        case 10:
        case 11:
        case 12:
        case 13:
        default: {
            [settings setValue:carPlaySetting forKey:@"carPlaySetting"];
            [settings setValue:contentPreviewSetting forKey:@"contentPreviewSetting"];
            break;
        }
    }
    
    return settings;
}

- (NSInteger)osMajorVersion {
    return [[[[UIDevice.currentDevice systemVersion] componentsSeparatedByString:@"."] firstObject] integerValue];
}

- (void)printPropertiesOfInstance:(id)instance {
    unsigned int outCount, i;
    
    NSMutableArray *propertyDescriptions = [NSMutableArray new];
    
    objc_property_t *properties = class_copyPropertyList([instance class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            // const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            //NSString *propertyType = [NSString stringWithUTF8String:propType];
            
            //[propertyDescriptions addObject:[NSString stringWithFormat:@"%@ %@", propertyName, propertyType]];
            [propertyDescriptions addObject:propertyName];
        }
    }
    free(properties);
    
    NSLog(@"%@", propertyDescriptions);
}

@end
