#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTRuntimeIssueDetectionPolicy;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTRuntimeIssueDetectionManager : NSObject
{
    XCTRuntimeIssueDetectionPolicy *_runtimeIssueDetectionPolicy;
}

+ (void)reportRuntimeIssue:(id)arg1;
+ (id)issueWithMessage:(id)arg1 callStackAddresses:(id)arg2;
+ (id)issueWithMessage:(id)arg1;
+ (instancetype)sharedRuntimeIssueDetectionManager;
@property(retain) XCTRuntimeIssueDetectionPolicy *runtimeIssueDetectionPolicy; // @synthesize runtimeIssueDetectionPolicy=_runtimeIssueDetectionPolicy;
- (void)startDetection;
@property(readonly) _Bool runtimeIssueDetectionEnabled;
- (id)initWithRuntimeIssueDetectionPolicy:(id)arg1;

@end

#endif