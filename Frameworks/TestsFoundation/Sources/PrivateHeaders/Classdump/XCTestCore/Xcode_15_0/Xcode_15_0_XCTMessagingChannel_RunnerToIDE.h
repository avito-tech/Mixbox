#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTMessagingRole_ActivityReporting.h"
#import "Xcode_15_0_XCTMessagingRole_DebugLogging.h"
#import "Xcode_15_0_XCTMessagingRole_PerformanceMeasurementReporting.h"
#import "Xcode_15_0_XCTMessagingRole_SelfDiagnosisIssueReporting.h"
#import "Xcode_15_0_XCTMessagingRole_TestReporting.h"
#import "Xcode_15_0_XCTMessagingRole_UIAutomation.h"
#import "Xcode_15_0__XCTMessaging_VoidProtocol.h"

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTMessagingChannel_RunnerToIDE <XCTMessagingRole_DebugLogging, XCTMessagingRole_TestReporting, XCTMessagingRole_SelfDiagnosisIssueReporting, XCTMessagingRole_UIAutomation, XCTMessagingRole_ActivityReporting, XCTMessagingRole_PerformanceMeasurementReporting, _XCTMessaging_VoidProtocol>

@optional
- (void)__dummy_method_to_work_around_68987191;
@end

#endif
