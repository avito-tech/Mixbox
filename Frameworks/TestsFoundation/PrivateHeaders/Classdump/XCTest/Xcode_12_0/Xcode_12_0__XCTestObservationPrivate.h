#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTest_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <XCTest/XCTestObservation.h>

@class XCActivityRecord, XCTContext;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol _XCTestObservationPrivate <XCTestObservation>

@optional
- (void)_context:(XCTContext *)arg1 didFinishActivity:(XCActivityRecord *)arg2;
- (void)_context:(XCTContext *)arg1 willStartActivity:(XCActivityRecord *)arg2;
@end

#endif