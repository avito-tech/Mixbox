#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTMessagingRole_SignpostRequesting
- (void)_XCT_unregisterForSignpostsWithToken:(NSUUID *)arg1;
- (void)_XCT_registerForSignpostsFromSubsystem:(NSString *)arg1 category:(NSString *)arg2 intervalTimeout:(double)arg3 reply:(void (^)(NSUUID *, NSError *))arg4;
@end

#endif
