// За основу взято это:
// https://github.com/wix/detox/blob/master/detox/ios/DetoxHelper/DetoxHelper/Extension/SetNotificationPermissionOperation.m

@import UIKit;
#import "NotificationPermissionsManager.h"

// For debugging
#import "objc/runtime.h"

@interface NotificationPermissionsManager()

@property(nonatomic, copy) NSString *bundleIdentifier;
@property(nonatomic, copy) NSString *displayName;

@end

@implementation NotificationPermissionsManager

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier displayName:(NSString *)displayName {
    if (self = [super init]) {
        _bundleIdentifier = [bundleIdentifier copy];
        _displayName = [displayName copy];
    }
    return self;
}

- (BOOL)setNotificationPermissionsStatus:(NSString *)status {
    __block NSError *error = nil;
    
    id sectionInfo = nil;
    
    if ([status isEqualToString:@"allowed"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:true];
    } else if ([status isEqualToString:@"denied"]) {
        sectionInfo = [self sectionInfoForForSettingNotificationsEnabled:false];
    } else if ([status isEqualToString:@"notDetermined"]) {
        // TODO: notDetermined не работает. Попробовать сделать.
        sectionInfo = nil;
    } else {
        return NO;
    }
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_group_enter(dispatchGroup);

    [self setSectionInfo:sectionInfo completionHandler:^(NSError *localError) {
        error = localError;
        
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    
    return error == nil;
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
    
    id completionHandlerCopy = [completionHandler copy];
    
    [invocation setArgument:&completionHandlerCopy atIndex:4];
    [invocation invoke];
}

- (id)sectionInfoForForSettingNotificationsEnabled:(BOOL)enabled {
    NSBundle *bundle = [self bulletinBoardFrameworkBundle];
    
    
    id sectionInfo = [[bundle classNamed:@"BBSectionInfo"] new];
    
    [self printPropertiesOfInstance:sectionInfo];
    
    [sectionInfo setValue:@NO forKey:@"suppressFromSettings"];
    [sectionInfo setValue:@0 forKey:@"suppressedSettings"];
    [sectionInfo setValue:@NO forKey:@"displaysCriticalBulletins"];
    [sectionInfo setValue:@0 forKey:@"sectionCategory"];
    [sectionInfo setValue:@0 forKey:@"subsectionPriority"];
    [sectionInfo setValue:@0 forKey:@"sectionType"];
    [sectionInfo setValue:@NO forKey:@"hideWeeApp"];
    [sectionInfo setValue:_displayName forKey:@"displayName"];
    [sectionInfo setValue:_bundleIdentifier forKey:@"sectionID"];
    
    switch ([self osMajorVersion]) {
        case 9: {
            break;
        }
        default: {
            [sectionInfo setValue:_displayName forKey:@"appName"];
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
    
    [settings setValue:alertType forKey:@"alertType"];
    [settings setValue:allowsNotifications forKey:@"allowsNotifications"];
    [settings setValue:pushSettings forKey:@"pushSettings"];
    [settings setValue:showsInLockScreen forKey:@"showsInLockScreen"];
    [settings setValue:showsInNotificationCenter forKey:@"showsInNotificationCenter"];
    [settings setValue:showsOnExternalDevices forKey:@"showsOnExternalDevices"];
    
    switch ([self osMajorVersion]) {
        case 9: {
            id showsMessagePreview = @NO;
            
            [settings setValue:showsMessagePreview forKey:@"showsMessagePreview"];
            break;
        }
        default: {
            id carPlaySetting = @NO;
            id contentPreviewSetting = @0;
            
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
