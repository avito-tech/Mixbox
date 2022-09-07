#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 170000

#import "Xcode_14_0_XCUIAutomation_CDStructures.h"
#import "Xcode_14_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class XCUIElement;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIElementBaseEventTarget : NSObject
{
    XCUIElement *_element;
}

+ (_Bool)_dispatchEventWithEventBuilder:(CDUnknownBlockType)arg1 eventSynthesizer:(id)arg2 withSnapshot:(id)arg3 applicationSnapshot:(id)arg4 process:(id)arg5 error:(id *)arg6;
+ (_Bool)_isInvalidEventDuration:(double)arg1;
+ (id)forElement:(id)arg1;
@property(readonly) XCUIElement *element; // @synthesize element=_element;
- (id)_clickElementSnapshot:(id)arg1 forDuration:(double)arg2 thenDragToElement:(id)arg3 withVelocity:(double)arg4 thenHoldFor:(double)arg5 error:(id *)arg6;
- (id)_highestNonWindowAncestorOfElement:(id)arg1 notSharedWithElement:(id)arg2;
- (_Bool)_tapWithNumberOfTaps:(unsigned long long)arg1 numberOfTouches:(unsigned long long)arg2 activityTitle:(id)arg3 error:(id *)arg4;
- (_Bool)_allUIInterruptionsHandledForElementSnapshot:(id)arg1 error:(id *)arg2;
- (id)_pointsInFrame:(struct CGRect)arg1 numberOfTouches:(unsigned long long)arg2;
- (_Bool)_shouldDispatchEvent:(id *)arg1;
- (_Bool)dispatchEventWithDescription:(id)arg1 eventBuilder:(CDUnknownBlockType)arg2 error:(id *)arg3;
- (_Bool)_dispatchEventWithEventBuilder:(CDUnknownBlockType)arg1 error:(id *)arg2;
- (id)_hitPointByAttemptingToScrollToVisibleSnapshot:(id)arg1 error:(id *)arg2;
- (id)initWithElement:(id)arg1;

@end

#endif