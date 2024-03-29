#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTestCaseIssueHandlingUIAutomationDelegate.h"
#import <XCTest/XCTestCase.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTestCase (UIAutomationDelegate) <XCTestCaseIssueHandlingUIAutomationDelegate>
+ (id)testRunConfigurationInputsForUITesting;
+ (_Bool)runsForEachTargetApplicationUIConfiguration;
- (void)tearDownSequence;
- (void)startingTestWithActivity:(id)arg1;
- (void)performingTestAfterInvokingTest;
- (id)_issueWithFailureScreenshotAttachedToIssue:(id)arg1;
- (void)removeUIInterruptionMonitor:(id)arg1;
- (id)addUIInterruptionMonitorWithDescription:(id)arg1 handler:(CDUnknownBlockType)arg2;

// Remaining properties
@end

#endif