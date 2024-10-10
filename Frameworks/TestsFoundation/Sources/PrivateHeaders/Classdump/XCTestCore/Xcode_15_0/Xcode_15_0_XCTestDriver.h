#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTRunnerIDESessionDelegate.h"
#import "Xcode_15_0_XCTestDriverUIAutomationDelegate.h"
#import <Foundation/Foundation.h>

@class XCTFuture, XCTPromise, XCTReportingSession, XCTRunnerIDESession, XCTestConfiguration;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTestDriver : NSObject <XCTestDriverUIAutomationDelegate, XCTRunnerIDESessionDelegate>
{
    XCTRunnerIDESession *_ideSession;
    NSURL *_testBundleURLFromEnvironment;
    NSUUID *_sessionIdentifierFromEnvironment;
    NSURL *_testConfigurationURLFromEnvironment;
    CDUnknownBlockType _daemonSessionProvider;
    XCTestConfiguration *_testConfiguration;
    NSBundle *_testBundle;
    id _testBundlePrincipalClassInstance;
    XCTFuture *_executionWorkerFuture;
    XCTPromise *_executionWorkerPromise;
    XCTReportingSession *_reportingSession;
}

+ (void)_applyRandomExecutionOrderingSeed:(id)arg1;
+ (_Bool)environmentSpecifiesTestConfiguration;
+ (_Bool)shouldSkipInitialBundleLoadBeforeXCTestMain;
+ (id)testBundleURLFromEnvironment;
+ (instancetype)sharedTestDriver;
+ (void)initializeSharedTestDriverWithRunConfiguration:(id)arg1;
@property(retain) id testBundlePrincipalClassInstance; // @synthesize testBundlePrincipalClassInstance=_testBundlePrincipalClassInstance;
@property(retain) NSBundle *testBundle; // @synthesize testBundle=_testBundle;
@property(retain) XCTestConfiguration *testConfiguration; // @synthesize testConfiguration=_testConfiguration;
@property(readonly, copy) CDUnknownBlockType daemonSessionProvider; // @synthesize daemonSessionProvider=_daemonSessionProvider;
@property(readonly, copy) NSURL *testConfigurationURLFromEnvironment; // @synthesize testConfigurationURLFromEnvironment=_testConfigurationURLFromEnvironment;
@property(readonly, copy) NSUUID *sessionIdentifierFromEnvironment; // @synthesize sessionIdentifierFromEnvironment=_sessionIdentifierFromEnvironment;
@property(readonly, copy) NSURL *testBundleURLFromEnvironment; // @synthesize testBundleURLFromEnvironment=_testBundleURLFromEnvironment;
@property(retain) XCTRunnerIDESession *ideSession; // @synthesize ideSession=_ideSession;
- (id)testWorkerForIDESession:(id)arg1;
- (void)IDESessionDidDisconnect:(id)arg1;
- (id)harnessEventReporter;
- (Class)_declaredPrincipalClassFromTestBundle:(id)arg1;
- (void)_createTestBundlePrincipalClassInstance;
- (id)_loadTestBundleFromURL:(id)arg1 error:(id *)arg2;
- (void)_reportBootstrappingFailure:(id)arg1;
- (id)_prepareIDESessionWithIdentifier:(id)arg1 exitCode:(int *)arg2;
- (void)_reportFinishedExecutingTests;
- (void)flushIDEConnectionAndExitWithCode:(int)arg1;
- (int)_runTests;
- (id)suspendAppSleep;
- (_Bool)_preTestingInitialization;
- (void)_configureGlobalState;
- (int)_prepareTestConfigurationAndIDESession;
- (int)run;
- (id)initWithTestConfiguration:(id)arg1;
- (id)initWithTestBundleURLFromEnvironment:(id)arg1 sessionIdentifierFromEnvironment:(id)arg2 testConfigurationURLFromEnvironment:(id)arg3 testConfiguration:(id)arg4 daemonSessionProvider:(CDUnknownBlockType)arg5;

// Remaining properties

@end

#endif