#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTRemoteSignpostListenerProxy.h"
#import "Xcode_15_0_XCTRunnerDaemonSessionUIAutomationDelegate.h"
#import <Foundation/Foundation.h>

@protocol XCTMessagingChannel_RunnerToDaemon, XCTSignpostListener, XCUIAXNotificationHandling, XCUIApplicationPlatformServicesProviderDelegate;

@class XCTCapabilities;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTRunnerDaemonSession : NSObject <XCTRunnerDaemonSessionUIAutomationDelegate, XCTRemoteSignpostListenerProxy>
{
    id <XCTSignpostListener> _signpostListener;
    NSXPCConnection *_connection;
    XCTCapabilities *_remoteInterfaceCapabilities;
    NSObject *_queue;
    NSMutableDictionary *_invalidationHandlers;
}

+ (void)capabilitiesForDaemonConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)sessionWithConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)initiateSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (void)initiateSharedSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (instancetype)sharedSessionIfInitiated;
+ (instancetype)sharedSession;
+ (instancetype)sharedSessionPromiseAndImplicitlyInitiateSession:(_Bool)arg1;
+ (id)connectionForInitiatingSharedSession;
+ (id)testmanagerdServiceName;
@property(retain) NSMutableDictionary *invalidationHandlers; // @synthesize invalidationHandlers=_invalidationHandlers;
@property(readonly) NSObject *queue; // @synthesize queue=_queue;
@property(readonly) XCTCapabilities *remoteInterfaceCapabilities; // @synthesize remoteInterfaceCapabilities=_remoteInterfaceCapabilities;
@property(readonly) NSXPCConnection *connection; // @synthesize connection=_connection;
@property __weak id <XCTSignpostListener> signpostListener; // @synthesize signpostListener=_signpostListener;
- (void)unregisterForSignpostsWithToken:(id)arg1;
- (void)_XCT_receivedSignpost:(id)arg1 withToken:(id)arg2;
- (void)registerForSignpostsFromSubsystem:(id)arg1 category:(id)arg2 intervalTimeout:(double)arg3 reply:(CDUnknownBlockType)arg4;
@property(readonly) _Bool supportsSignpostListening;
- (void)postTelemetryData:(id)arg1 reply:(CDUnknownBlockType)arg2;
@property(readonly) _Bool supportsPostingTelemetryData;
- (void)requestTailspinWithRequest:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestSpindumpWithSpecification:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestIDEConnectionTransportForSessionIdentifier:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)_XCT_receivedAccessibilityNotification:(int)arg1 fromElement:(id)arg2 payload:(id)arg3;
- (void)_XCT_receivedAccessibilityNotification:(int)arg1 withPayload:(id)arg2;
@property(readonly) id <XCTMessagingChannel_RunnerToDaemon> daemonProxy;
- (void)unregisterInvalidationHandlerWithToken:(id)arg1;
- (id)registerInvalidationHandler:(CDUnknownBlockType)arg1;
- (void)_reportInvalidation;
- (id)initWithConnection:(id)arg1 remoteInterfaceCapabilities:(id)arg2;
- (void)dealloc;

// Remaining properties
@property __weak id <XCUIAXNotificationHandling> axNotificationHandler;
@property __weak id <XCUIApplicationPlatformServicesProviderDelegate> platformApplicationServicesProviderDelegate;
@property(readonly) _Bool useLegacyEventCoordinateTransformationPath;
@property(readonly) _Bool usePointTransformationsForFrameConversions;

@end

#endif