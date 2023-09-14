// Based on:
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

@protocol BBSectionInfoSettings <NSObject>

@property (nonatomic) unsigned long alertType;
@property (nonatomic) BOOL allowsNotifications;
@property (nonatomic) unsigned long pushSettings;
@property (nonatomic) BOOL showsInLockScreen;
@property (nonatomic) BOOL showsInNotificationCenter;
@property (nonatomic) BOOL showsOnExternalDevices;
@property (nonatomic) long carPlaySetting;
@property (nonatomic) long contentPreviewSetting;

- (void)setValue:(nullable id)value forKey:(NSString *)key;

@end

@protocol BBSectionInfo <NSObject>

@property (nonatomic) BOOL suppressFromSettings;
@property (nonatomic) unsigned long suppressedSettings;
@property (nonatomic) long sectionCategory;
@property (nonatomic) long subsectionPriority;
@property (nonatomic) long sectionType;
@property (nonatomic) BOOL hideWeeApp;
@property (copy, nonatomic) NSString* displayName;
@property (copy, nonatomic) NSString* sectionID;
@property (nonatomic) BOOL displaysCriticalBulletins; // iOS 9 (or maybe lower) -> iOS 12. Unavailable in iOS 13.
@property (copy, nonatomic) id<BBSectionInfoSettings> sectionInfoSettings;

- (void)setValue:(nullable id)value forKey:(NSString *)key;

@end

@protocol BBSettingsGateway <NSObject>

- (void)setSectionInfo:(id<BBSectionInfo>)a0 forSectionID:(NSString *)a1 withCompletion:(id)a2;
- (id<BBSectionInfo>)sectionInfoForSectionID:(NSString *)a0;

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
    id<BBSectionInfo> sectionInfo = nil;
    
    if ([status isEqualToString:@"allowed"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:YES];
    } else if ([status isEqualToString:@"denied"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:NO];
    } else if ([status isEqualToString:@"notDetermined"]) {
        // TODO: notDetermined doesn't work.
        sectionInfo = nil;
    } else {
        return [ErrorString stringWithFormat:@"status is not supported: %@", status];
    }
    
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    id<BBSettingsGateway> settingsGateway = [[bundle classNamed:@"BBSettingsGateway"] new];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();

    dispatch_group_enter(dispatchGroup);
    
    __block BOOL completionHandlerWasCalled = NO;
    
    [settingsGateway setSectionInfo:sectionInfo forSectionID:_bundleIdentifier withCompletion:^{
        completionHandlerWasCalled = YES;

        dispatch_group_leave(dispatchGroup);
    }];

    dispatch_group_wait(dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)));
    
    id<BBSectionInfo> sectionInfoAfterSetting = [settingsGateway sectionInfoForSectionID:_bundleIdentifier];
    
    NSString *error = nil;
    
    if (![self isSectionInfoApplied:sectionInfo actualSectionInfo:sectionInfoAfterSetting]) {
        NSString *errorSuffix = completionHandlerWasCalled ? @"" : @", also completion handler of -setSectionInfo:forSectionID:withCompletion: was not called (it was not expected and is an indication of an error)";
        
        NSString *error = [ErrorString stringWithFormat:
                 @"Failed to setSectionInfo. Section info  %@ receinved after setSectionInfo does not have certain desired attributes of expected section %@%@",
                 sectionInfoAfterSetting,
                 sectionInfo,
                 errorSuffix
        ];
        
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

- (id<BBSectionInfo>)sectionInfoForForSettingNotificationsEnabled:(BOOL)enabled {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    id<BBSectionInfo> sectionInfo = [[bundle classNamed:@"BBSectionInfo"] new];
    
    [self printPropertiesOfInstance:sectionInfo];
    
    sectionInfo.suppressFromSettings = NO;
    sectionInfo.suppressedSettings = 0;
    sectionInfo.sectionCategory = 0;
    sectionInfo.subsectionPriority = 0;
    sectionInfo.sectionType = 0;
    sectionInfo.hideWeeApp = NO;
    sectionInfo.displayName = _displayName;
    sectionInfo.sectionID = _bundleIdentifier;
    
    switch ([self osMajorVersion]) {
        case 9:
        case 10:
        case 11:
        case 12: {
            sectionInfo.displaysCriticalBulletins = NO;
            break;
        }
        case 13:
        default: {
            // New `spokenNotificationSetting` field appeared, but it is `long` and it is unclear how to set it up.
            break;
        }
    }
    
    id<BBSectionInfoSettings> settings = [self sectionInfoSettingsForForSettingNotificationsEnabled:enabled];
    
    sectionInfo.sectionInfoSettings = settings;
    
    return sectionInfo;
}

- (BOOL)isSectionInfoApplied:(id<BBSectionInfo>)expectedSectionInfo actualSectionInfo:(id<BBSectionInfo>)actualSectionInfo {
    if (expectedSectionInfo.sectionInfoSettings.allowsNotifications != actualSectionInfo.sectionInfoSettings.allowsNotifications) {
        return NO;
    }
    if (![expectedSectionInfo.displayName isEqual:actualSectionInfo.displayName]) {
        return NO;
    }
    if (![expectedSectionInfo.sectionID isEqual:actualSectionInfo.sectionID]) {
        return NO;
    }
    return YES;
}

- (id<BBSectionInfoSettings>)sectionInfoSettingsForForSettingNotificationsEnabled:(BOOL)enabled {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    id<BBSectionInfoSettings> settings = [[bundle classNamed:@"BBSectionInfoSettings"] new];
    
    [self printPropertiesOfInstance:settings];
    
    settings.alertType = 1;
    settings.allowsNotifications = enabled;
    settings.pushSettings = 63;
    settings.showsInLockScreen = YES;
    settings.showsInNotificationCenter = YES;
    settings.showsOnExternalDevices = YES;
    settings.carPlaySetting = NO;
    settings.contentPreviewSetting = 0;
    
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
