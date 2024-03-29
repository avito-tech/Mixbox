#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@protocol XCTMessagingRole_TestReporting;

@class XCTTestIdentifier;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTReportingSessionSuiteReporter : NSObject
{
    XCTTestIdentifier *_identifier;
    id <XCTMessagingRole_TestReporting> _IDEProxy;
    NSDate *_startDate;
    double _totalTestDuration;
    long long _totalTestCount;
    NSMutableDictionary *_testCountByStatus;
}

@property(readonly) XCTTestIdentifier *identifier; // @synthesize identifier=_identifier;
- (void)finishAtDate:(id)arg1;
- (void)reportIssue:(id)arg1 atDate:(id)arg2;
- (id)reportTestStartedWithName:(id)arg1 atDate:(id)arg2 iteration:(long long)arg3;
- (id)reportTestStartedWithName:(id)arg1 atDate:(id)arg2;
- (id)reportSuiteStartedWithName:(id)arg1 atDate:(id)arg2;

@end

#endif