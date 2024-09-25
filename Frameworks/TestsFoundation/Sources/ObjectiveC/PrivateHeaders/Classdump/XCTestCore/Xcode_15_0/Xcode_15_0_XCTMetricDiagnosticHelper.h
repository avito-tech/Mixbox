#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCTAttachmentManager, XCTMeasureOptions, XCTTestIdentifier;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTMetricDiagnosticHelper : NSObject
{
    NSArray *_metrics;
    NSArray *_memoryMetrics;
    XCTAttachmentManager *_attachmentManager;
    XCTTestIdentifier *_testIdentifier;
    XCTMeasureOptions *_measureOptions;
}

+ (id)generateRandomString;
@property(copy, nonatomic) XCTMeasureOptions *measureOptions; // @synthesize measureOptions=_measureOptions;
@property(retain) XCTTestIdentifier *testIdentifier; // @synthesize testIdentifier=_testIdentifier;
@property(copy, nonatomic) NSArray *memoryMetrics; // @synthesize memoryMetrics=_memoryMetrics;
@property(copy, nonatomic) NSArray *metrics; // @synthesize metrics=_metrics;
- (void)addAttachment:(id)arg1;
- (void)attachPerfdataFileCollected:(id)arg1;
- (void)attachTraceFileCollectedForInstrument:(id)arg1;
- (void)sendMetricUseToCoreAnalytics:(id)arg1;
- (void)_applyXcodebuildCommandLineOverridesToOptions:(id)arg1;
- (void)_applyDefaultTraceName;
- (id)_generateTraceName;
- (id)_sanitizeFileNameString:(id)arg1;
- (id)initWithMetrics:(id)arg1 attachmentManager:(id)arg2 options:(id)arg3 testIdentifier:(id)arg4;

@end

#endif