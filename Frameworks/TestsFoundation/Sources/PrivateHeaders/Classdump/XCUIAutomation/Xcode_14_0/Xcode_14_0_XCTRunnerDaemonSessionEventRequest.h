#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import "Xcode_14_0_XCUIEventSynthesisRequest.h"
#import <Foundation/Foundation.h>

@class XCSynthesizedEventRecord;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface XCTRunnerDaemonSessionEventRequest : NSObject <XCUIEventSynthesisRequest>
{
    XCSynthesizedEventRecord *_event;
    double _upperBoundOnDuration;
}

@property double upperBoundOnDuration; // @synthesize upperBoundOnDuration=_upperBoundOnDuration;
@property(readonly) XCSynthesizedEventRecord *event; // @synthesize event=_event;
- (void)invalidate;
- (id)initWithEvent:(id)arg1;

// Remaining properties

@end

#endif