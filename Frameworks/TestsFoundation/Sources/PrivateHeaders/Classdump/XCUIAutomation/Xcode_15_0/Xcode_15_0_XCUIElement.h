#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCUIAutomation_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTNSPredicateExpectationObject.h"
#import "Xcode_15_0_XCUIElementAttributesPrivate.h"
#import "Xcode_15_0_XCUIElementTypeQueryProvider_Private.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCUIElement.h>
#import <XCTest/XCUIElementAttributes.h>
#import <XCTest/XCUIElementTypeQueryProvider.h>

@protocol XCUIDevice, XCUIElementEventTarget;

@class Bool, XCElementSnapshot, XCTLocalizableStringInfo, XCUIApplication, XCUICoordinate, XCUIElement, XCUIElementQuery, XCUIScreen;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCUIElement ()
{
    _Bool _safeQueryResolutionEnabled;
    XCUIElementQuery *_query;
    XCElementSnapshot *_lastSnapshot;
}

+ (id)standardAttributeNames;
+ (_Bool)_dispatchEventWithEventBuilder:(CDUnknownBlockType)arg1 eventSynthesizer:(id)arg2 withSnapshot:(id)arg3 applicationSnapshot:(id)arg4 process:(id)arg5 error:(id *)arg6;
+ (_Bool)_isInvalidEventDuration:(double)arg1;

@property _Bool safeQueryResolutionEnabled; // @synthesize safeQueryResolutionEnabled=_safeQueryResolutionEnabled;
@property(retain) XCElementSnapshot *lastSnapshot; // @synthesize lastSnapshot=_lastSnapshot;
@property(readonly) XCUIElementQuery *query; // @synthesize query=_query;
@property(readonly, copy) XCUIElementQuery *bannerNotifications;

@property(readonly, copy) XCUICoordinate *hitPointCoordinate;
@property(readonly) id <XCUIElementEventTarget> eventTarget;
@property(readonly) _Bool bannerNotificationIsSticky;
@property(readonly) _Bool hasBannerNotificationIsStickyAttribute;
- (id)valueForAccessibilityAttribute:(id)arg1 error:(id *)arg2;
- (id)valuesForAccessibilityAttributes:(id)arg1 error:(id *)arg2;
@property(readonly) _Bool isTopLevelTouchBarElement;
@property(readonly) _Bool isTouchBarElement;
- (void)handleUIInterruptions;
@property(readonly) _Bool hasUIInterruptions;
@property(readonly) long long displayID;
@property(readonly, nonatomic) long long interfaceOrientation;
- (unsigned long long)traits;
@property(readonly) _Bool hasKeyboardFocus;
@property(readonly, copy) XCTLocalizableStringInfo *localizableStringInfo;
@property(readonly) struct CGRect screenshotFrame;
- (void)_captureDebugInformation;
- (_Bool)resolveOrRaiseTestFailure:(_Bool)arg1 error:(id *)arg2;
- (void)resolveOrRaiseTestFailure;
- (_Bool)_waitForHittableWithTimeout:(double)arg1;
- (_Bool)_waitForNonExistenceWithTimeout:(double)arg1;
- (id)makeNonExistenceExpectation;

- (_Bool)_waitForExistenceWithTimeout:(double)arg1;
- (_Bool)evaluatePredicateForExpectation:(id)arg1 debugMessage:(id *)arg2;
- (id)_debugDescriptionWithSnapshot:(id)arg1 noMatchesMessage:(id)arg2;
@property(readonly, copy) NSString *compactDescription;
@property(readonly, copy) XCUIElement *excludingNonModalElements;
@property(readonly, copy) XCUIElement *includingNonModalElements;
- (id)_childrenMatchingTypes:(id)arg1;

- (id)_descendantsMatchingTypes:(id)arg1;

- (_Bool)existsNoRetry;
@property(readonly) XCUIScreen *screen;
@property(readonly) id <XCUIDevice> device;
@property(readonly, nonatomic) XCUIApplication *application;
@property(readonly, copy) XCUIElement *elementBoundByAccessibilityElement;
- (id)initWithElementQuery:(id)arg1;

- (_Bool)_allUIInterruptionsHandledForElementSnapshot:(id)arg1 error:(id *)arg2;
- (_Bool)_shouldDispatchEvent:(id *)arg1;
- (void)_dispatchEvent:(id)arg1 eventBuilder:(DispatchEventEventBuilder)arg2;
- (_Bool)_dispatchEventWithEventBuilder:(CDUnknownBlockType)arg1 error:(id *)arg2;

- (_Bool)_focusValidForElementSnapshot:(id)arg1 error:(id *)arg2;

- (void)swipeRight;
- (void)swipeLeft;
- (void)swipeDown;
- (void)swipeUp;
- (void)_swipe:(unsigned long long)arg1 withVelocity:(double)arg2;
- (void)_pressWithPressure:(double)arg1 pressDuration:(double)arg2 holdDuration:(double)arg3 releaseDuration:(double)arg4 activityTitle:(id)arg5;

- (id)_highestNonWindowAncestorOfElement:(id)arg1 notSharedWithElement:(id)arg2;

- (void)twoFingerTap;
- (void)doubleTap;
- (void)tap;
- (id)_hitPointByAttemptingToScrollToVisibleSnapshot:(id)arg1 error:(id *)arg2;
- (id)_clickElementSnapshot:(id)arg1 forDuration:(double)arg2 thenDragToElement:(id)arg3 withVelocity:(double)arg4 thenHoldFor:(double)arg5;

- (void)rightClick;
- (void)doubleClick;
- (void)click;
- (void)hover;

- (id)_normalizedSliderPositionForSnapshot:(id)arg1 isVertical:(_Bool *)arg2 error:(id *)arg3;
- (id)_iOSSliderAdjustmentEventWithTargetPosition:(double)arg1 snapshot:(id)arg2 error:(id *)arg3;
- (id)_normalizedUISliderPositionForSnapshot:(id)arg1 isVertical:(_Bool *)arg2 error:(id *)arg3;

- (void)pressWithPressure:(double)arg1 duration:(double)arg2;
- (void)forcePress;
- (void)tapOrClick;
- (void)scrollToVisible;
- (void)tripleClick;
- (void)clickForDuration:(double)arg1;
- (void)playBackEventStreamAtURL:(id)arg1 withSpeed:(double)arg2;
- (id)screenshotAttachmentWithPreferredEncoding:(id)arg1 options:(unsigned long long)arg2;
- (id)screenshotWithPreferredEncoding:(id)arg1 options:(unsigned long long)arg2;
- (id)screenshotAttachmentWithName:(id)arg1 lifetime:(long long)arg2;
- (id)screenshotAttachment;

// Remaining properties

@end

#endif