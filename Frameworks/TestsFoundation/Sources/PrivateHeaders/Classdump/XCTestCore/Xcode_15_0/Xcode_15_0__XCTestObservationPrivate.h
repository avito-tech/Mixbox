#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <XCTest/XCTestObservation.h>

@class XCActivityRecord, XCTContext, XCTSourceCodeContext, XCTestCase;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol _XCTestObservationPrivate <XCTestObservation>

@optional
- (void)testCase:(XCTestCase *)arg1 didRecordSkipWithDescription:(NSString *)arg2 sourceCodeContext:(XCTSourceCodeContext *)arg3;
- (void)_context:(XCTContext *)arg1 didFinishActivity:(XCActivityRecord *)arg2;
- (void)_context:(XCTContext *)arg1 willStartActivity:(XCActivityRecord *)arg2;
@end

#endif
