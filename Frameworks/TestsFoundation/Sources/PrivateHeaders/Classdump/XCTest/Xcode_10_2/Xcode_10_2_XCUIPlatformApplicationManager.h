#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120200 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120400

#import "Xcode_10_2_XCTest_CDStructures.h"
#import "Xcode_10_2_SharedHeader.h"
#import "Xcode_10_2_XCUIApplicationManaging.h"
#import <Foundation/Foundation.h>

@protocol XCUIPlatformApplicationServicesProviding;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIPlatformApplicationManager : NSObject <XCUIApplicationManaging>
{
    id <XCUIPlatformApplicationServicesProviding> _platformApplicationServicesProvider;
}

+ (_Bool)_shouldRetryForLaunchError:(id)arg1;
@property(readonly) id <XCUIPlatformApplicationServicesProviding> platformApplicationServicesProvider; // @synthesize platformApplicationServicesProvider=_platformApplicationServicesProvider;
- (void)launchProcessWithPath:(id)arg1 bundleID:(id)arg2 arguments:(id)arg3 environmentVariables:(id)arg4 completion:(CDUnknownBlockType)arg5;
- (id)initWithPlatformApplicationServicesProvider:(id)arg1;

// Remaining properties

@end

#endif