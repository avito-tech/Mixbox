#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <XCTest/XCTest.h>

@class XCTTestIdentifier;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTestCasePlaceholder : XCTest
{
    XCTTestIdentifier *_identifier;
    NSString *_reason;
}

@property(readonly, copy) NSString *reason; // @synthesize reason=_reason;
- (id)_xctTestIdentifier;
- (long long)defaultExecutionOrderCompare:(id)arg1;
- (_Bool)isEqual:(id)arg1;
- (void)performTest:(id)arg1;
- (Class)testRunClass;
- (Class)_requiredTestRunBaseClass;
- (id)nameForLegacyLogging;
- (id)name;
- (unsigned long long)testCaseCount;
- (id)initWithIdentifier:(id)arg1 reason:(id)arg2;

@end

#endif