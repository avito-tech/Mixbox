#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTMetric_Private.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTMetric.h>

@class MXMOSSignpostMetric;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTApplicationLaunchMetric ()
{
    NSString *_instrumentationName;
    MXMOSSignpostMetric *__underlyingMetric;
}

@property(retain, nonatomic) MXMOSSignpostMetric *_underlyingMetric; // @synthesize _underlyingMetric=__underlyingMetric;
@property(readonly, nonatomic) NSString *instrumentationName; // @synthesize instrumentationName=_instrumentationName;
- (id)reportMeasurementsFromStartTime:(id)arg1 toEndTime:(id)arg2 error:(id *)arg3;
- (void)didStopMeasuringAtTimestamp:(id)arg1;
- (void)didStartMeasuringAtTimestamp:(id)arg1;
- (void)willBeginMeasuringAtEstimatedTimestamp:(id)arg1;
- (void)prepareToMeasureWithOptions:(id)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)initWithUnderlyingMetric:(id)arg1;
- (id)initWithSubsystem:(id)arg1 category:(id)arg2 name:(id)arg3;

// Remaining properties

@end

#endif