#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"

@class CLLocation;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTMessagingRole_SystemConfiguration
- (void)_XCT_clearSimulatedLocationWithReply:(void (^)(NSError *))arg1;
- (void)_XCT_setSimulatedLocation:(CLLocation *)arg1 reply:(void (^)(NSError *))arg2;
- (void)_XCT_getSimulatedLocationWithReply:(void (^)(CLLocation *, NSError *))arg1;
- (void)_XCT_getAppearanceModeWithReply:(void (^)(long long, NSError *))arg1;
- (void)_XCT_updateAppearanceMode:(long long)arg1 completion:(void (^)(NSError *))arg2;
@end

#endif
