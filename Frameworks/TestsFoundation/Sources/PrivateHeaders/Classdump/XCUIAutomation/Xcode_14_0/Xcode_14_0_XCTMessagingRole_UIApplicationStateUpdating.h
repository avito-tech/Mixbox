#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"

@class XCTApplicationStateSnapshot;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTMessagingRole_UIApplicationStateUpdating
- (void)_XCT_applicationDidUpdateState:(XCTApplicationStateSnapshot *)arg1;
- (void)_XCT_applicationWithBundleID:(NSString *)arg1 didUpdatePID:(int)arg2 andState:(unsigned long long)arg3;
@end

#endif
