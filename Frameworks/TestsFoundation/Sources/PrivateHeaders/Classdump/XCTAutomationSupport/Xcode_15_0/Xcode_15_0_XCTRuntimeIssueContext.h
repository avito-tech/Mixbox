#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTCapabilities;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTRuntimeIssueContext : NSObject
{
    XCTCapabilities *_capabilities;
    Class _reportingDelegate;
    NSMutableOrderedSet *_mutableRuntimeIssues;
}

+ (id)aggregationOfRuntimeIssues:(id)arg1;
+ (void)reportRuntimeIssues:(id)arg1;
+ (void)reportRuntimeIssue:(id)arg1;
+ (void)captureIssuesWithContext:(id)arg1 inScope:(CDUnknownBlockType)arg2;
+ (id)currentContext;
@property(retain) NSMutableOrderedSet *mutableRuntimeIssues; // @synthesize mutableRuntimeIssues=_mutableRuntimeIssues;
@property(readonly) __weak Class reportingDelegate; // @synthesize reportingDelegate=_reportingDelegate;
@property(readonly, copy) XCTCapabilities *capabilities; // @synthesize capabilities=_capabilities;
@property(readonly, copy) NSOrderedSet *runtimeIssues;
- (void)reportRuntimeIssue:(id)arg1;
- (id)init;
- (id)initWithCapabilities:(id)arg1 reportingDelegate:(Class)arg2;

@end

#endif