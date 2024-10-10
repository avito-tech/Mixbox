#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class CLLocation, XCDeviceEvent;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCUIDeviceEventAndStateInterface <NSObject>
@property(readonly) _Bool supportsHandGestures;
@property(readonly) _Bool supportsLocationSimulation;
@property(readonly) _Bool supportsAppearanceMode;
- (void)hasHardwareButton:(long long)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)clearSimulatedLocationWithReply:(void (^)(_Bool, NSError *))arg1;
- (void)setSimulatedLocation:(CLLocation *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)getSimulatedLocationWithReply:(void (^)(CLLocation *, NSError *))arg1;
- (void)getInterfaceOrientationWithReply:(void (^)(long long, NSError *))arg1;
- (void)getAppearanceModeWithReply:(void (^)(long long, NSError *))arg1;
- (void)updateAppearanceMode:(long long)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)getDeviceOrientationWithCompletion:(void (^)(long long, NSError *))arg1;
- (void)updateDeviceOrientation:(long long)arg1 completion:(void (^)(_Bool, NSError *))arg2;
- (void)performDeviceEvent:(XCDeviceEvent *)arg1 completion:(void (^)(_Bool, NSError *))arg2;
@end

#endif