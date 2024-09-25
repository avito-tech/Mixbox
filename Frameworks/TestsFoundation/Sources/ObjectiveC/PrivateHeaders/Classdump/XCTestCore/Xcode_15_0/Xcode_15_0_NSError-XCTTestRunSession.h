#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTSkippedTestContext;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface NSError (XCTTestRunSession)
- (id)xct_initWithTestSuiteConstructionException:(id)arg1 orDescription:(id)arg2;
- (id)xct_initWithTestSuiteConstructionException:(id)arg1;
@property(readonly) _Bool xct_isFutureTimeout;
@property(readonly) _Bool xct_isFutureCancelation;
@property(readonly) XCTSkippedTestContext *xct_skippedTestContext;
@property(readonly) _Bool xct_shouldBeRecordedAsTestFailure;
@end

#endif