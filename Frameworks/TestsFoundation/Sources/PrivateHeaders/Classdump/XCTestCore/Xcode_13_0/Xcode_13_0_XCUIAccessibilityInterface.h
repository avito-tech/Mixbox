#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import "Xcode_13_0_XCTElementSnapshotAttributeDataSource.h"
#import "Xcode_13_0_XCUIAXNotificationHandling.h"
#import <Foundation/Foundation.h>

@class Bool, XCAXAuditConfiguration, XCAXAuditResultCollection, XCAccessibilityElement, XCElementSnapshot, XCTestExpectation, XCUIAccessibilityAction, XCUIApplicationProcess, XCUIElementSnapshotRequestResult;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCUIAccessibilityInterface <NSObject, XCUIAXNotificationHandling, XCTElementSnapshotAttributeDataSource>
@property(readonly, nonatomic) XCAccessibilityElement *systemApplication;
@property(readonly) _Bool supportsAnimationsInactiveNotifications;
@property double AXTimeout;
- (XCAccessibilityElement *)accessibilityElementForElementAtPoint:(struct CGPoint)arg1 error:(id *)arg2;
- (void)performWhenMenuOpens:(XCAccessibilityElement *)arg1 block:(void (^)(void))arg2;
- (void)removeObserver:(id)arg1 forAXNotification:(NSString *)arg2;
- (id)addObserverForAXNotification:(NSString *)arg1 handler:(void (^)(XCAccessibilityElement *, NSDictionary *))arg2;
- (void)unregisterForAXNotificationsForApplicationWithPID:(int)arg1;
- (void)registerForAXNotificationsForApplicationWithPID:(int)arg1 timeout:(double)arg2 completion:(void (^)(_Bool, NSError *))arg3;
- (NSArray *)localizableStringsDataForActiveApplications;
- (void)waitForQuiescenceOnAllForegroundApplications;
- (_Bool)enableFauxCollectionViewCells:(id *)arg1;
- (void)notifyWhenViewControllerViewDidDisappearReply:(void (^)(NSDictionary *, NSError *))arg1;
- (XCTestExpectation *)viewDidAppearExpectationForElement:(XCAccessibilityElement *)arg1 viewControllerName:(NSString *)arg2;
- (void)notifyWhenNoAnimationsAreActiveForApplication:(XCUIApplicationProcess *)arg1 reply:(void (^)(NSDictionary *, NSError *))arg2;
- (void)notifyOnNextOccurrenceOfUserTestingEvent:(NSString *)arg1 handler:(void (^)(NSDictionary *, NSError *))arg2;
- (_Bool)cachedAccessibilityLoadedValueForPID:(int)arg1;
- (id)parameterizedAttribute:(NSString *)arg1 forElement:(XCAccessibilityElement *)arg2 parameter:(id)arg3 error:(id *)arg4;
- (_Bool)setAttribute:(NSString *)arg1 value:(id)arg2 element:(XCAccessibilityElement *)arg3 outError:(id *)arg4;
- (XCAXAuditResultCollection *)runAccessibilityAuditForApplication:(XCUIApplicationProcess *)arg1 withConfiguration:(XCAXAuditConfiguration *)arg2 error:(id *)arg3;
- (XCUIElementSnapshotRequestResult *)requestSnapshotForElement:(XCAccessibilityElement *)arg1 attributes:(NSArray *)arg2 parameters:(NSDictionary *)arg3 error:(id *)arg4;
- (void)notifyWhenEventLoopIsIdleForApplication:(XCUIApplicationProcess *)arg1 reply:(void (^)(NSDictionary *, NSError *))arg2;
- (_Bool)performAction:(XCUIAccessibilityAction *)arg1 onElement:(XCAccessibilityElement *)arg2 value:(id)arg3 error:(id *)arg4;
- (XCAccessibilityElement *)hitTestElement:(XCElementSnapshot *)arg1 withPoint:(struct CGPoint)arg2 error:(id *)arg3;
- (NSArray *)interruptingUIElementsAffectingSnapshot:(XCElementSnapshot *)arg1 checkForHandledElement:(XCAccessibilityElement *)arg2 containsHandledElement:(_Bool *)arg3;
- (_Bool)isValidElement:(XCAccessibilityElement *)arg1;
- (_Bool)unloadAccessibility:(id *)arg1;
- (_Bool)loadAccessibility:(id *)arg1;
@end

#endif
