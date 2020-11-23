#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 150000

#import "Xcode_12_0_XCTest_CDStructures.h"
#import "Xcode_12_0_SharedHeader.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol MXMInstrumental <NSCopying>
- (_Bool)harvestData:(id *)arg1 error:(id *)arg2;

@optional
- (void)didStopAtContinuousTime:(unsigned long long)arg1 absoluteTime:(unsigned long long)arg2 stopDate:(NSDate *)arg3;
- (void)didStartAtContinuousTime:(unsigned long long)arg1 absoluteTime:(unsigned long long)arg2 startDate:(NSDate *)arg3;
- (void)didStopAtTime:(unsigned long long)arg1 stopDate:(NSDate *)arg2;
- (void)willStop;
- (void)didStartAtTime:(unsigned long long)arg1 startDate:(NSDate *)arg2;
- (void)willStartAtEstimatedTime:(unsigned long long)arg1;
- (_Bool)prepareWithOptions:(NSDictionary *)arg1 error:(id *)arg2;
@end

#endif