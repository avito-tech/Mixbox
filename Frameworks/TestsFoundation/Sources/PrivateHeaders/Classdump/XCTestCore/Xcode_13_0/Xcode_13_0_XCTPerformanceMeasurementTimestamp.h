#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTMetric.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTPerformanceMeasurementTimestamp ()
{
    _Bool _hasContinuousTime;
    unsigned long long _continuousTime;
    unsigned long long _absoluteTime;
    NSDate *_date;
}

@property(readonly) _Bool hasContinuousTime; // @synthesize hasContinuousTime=_hasContinuousTime;
@property(readonly) unsigned long long continuousTime; // @synthesize continuousTime=_continuousTime;
- (id)initWithContinuousTime:(unsigned long long)arg1 absoluteTime:(unsigned long long)arg2 date:(id)arg3;
- (id)init;

@end

#endif