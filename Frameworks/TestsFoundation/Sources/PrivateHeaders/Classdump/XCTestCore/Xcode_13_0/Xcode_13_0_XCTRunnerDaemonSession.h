#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import "Xcode_13_0_XCTMessagingChannel_DaemonToRunner.h"
#import "Xcode_13_0_XCTRemoteSignpostListenerProxy.h"
#import "Xcode_13_0_XCUIApplicationAutomationSessionProviding.h"
#import "Xcode_13_0_XCUIDeviceAutomationModeInterface.h"
#import "Xcode_13_0_XCUIDeviceEventAndStateInterface.h"
#import "Xcode_13_0_XCUIEventSynthesizing.h"
#import "Xcode_13_0_XCUILocalDeviceScreenshotIPCInterface.h"
#import "Xcode_13_0_XCUIPlatformApplicationServicesProviding.h"
#import "Xcode_13_0_XCUIRemoteAccessibilityInterface.h"
#import "Xcode_13_0_XCUIRemoteSiriInterface.h"
#import "Xcode_13_0_XCUIResetAuthorizationStatusOfProtectedResourcesInterface.h"
#import <Foundation/Foundation.h>

@protocol XCTMessagingChannel_RunnerToDaemon, XCTSignpostListener, XCUIAXNotificationHandling, XCUIApplicationPlatformServicesProviderDelegate;

@class XCTCapabilities;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTRunnerDaemonSession : NSObject <XCUIResetAuthorizationStatusOfProtectedResourcesInterface, XCUIDeviceAutomationModeInterface, XCUIRemoteSiriInterface, XCUILocalDeviceScreenshotIPCInterface, XCUIApplicationAutomationSessionProviding, XCUIDeviceEventAndStateInterface, XCUIPlatformApplicationServicesProviding, XCTMessagingChannel_DaemonToRunner, XCUIRemoteAccessibilityInterface, XCUIEventSynthesizing, XCTRemoteSignpostListenerProxy>
{
    id <XCTSignpostListener> _signpostListener;
    double _implicitEventConfirmationIntervalForCurrentContext;
    NSXPCConnection *_connection;
    XCTCapabilities *_remoteInterfaceCapabilities;
    id <XCUIApplicationPlatformServicesProviderDelegate> _platformApplicationServicesProviderDelegate;
    id <XCUIAXNotificationHandling> _axNotificationHandler;
    NSObject *_queue;
    NSMutableDictionary *_invalidationHandlers;
}

+ (id)daemonCapabilitiesForProtocolVersion:(unsigned long long)arg1 platform:(unsigned long long)arg2 error:(id *)arg3;
+ (id)capabilities;
+ (void)legacyCapabilitiesForDaemonConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)modernCapabilitiesForDaemonConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)capabilitiesForDaemonConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)sessionWithConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (void)initiateSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (void)initiateSharedSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (instancetype)sharedSessionIfInitiated;
+ (instancetype)sharedSession;
+ (instancetype)sharedSessionPromiseAndImplicitlyInitiateSession:(_Bool)arg1;
+ (id)connectionForInitiatingSharedSession;
+ (id)unsupportedBundleIdentifiersForAutomationSessions;
@property(retain) NSMutableDictionary *invalidationHandlers; // @synthesize invalidationHandlers=_invalidationHandlers;
@property(readonly) NSObject *queue; // @synthesize queue=_queue;
@property __weak id <XCUIAXNotificationHandling> axNotificationHandler; // @synthesize axNotificationHandler=_axNotificationHandler;
@property __weak id <XCUIApplicationPlatformServicesProviderDelegate> platformApplicationServicesProviderDelegate; // @synthesize platformApplicationServicesProviderDelegate=_platformApplicationServicesProviderDelegate;
@property(readonly) XCTCapabilities *remoteInterfaceCapabilities; // @synthesize remoteInterfaceCapabilities=_remoteInterfaceCapabilities;
@property(readonly) NSXPCConnection *connection; // @synthesize connection=_connection;
@property __weak id <XCTSignpostListener> signpostListener; // @synthesize signpostListener=_signpostListener;
@property(readonly) unsigned long long currentKeyboardModifierFlags;
- (void)playBackHIDEventRecordingFromData:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)stopHIDEventRecordingWithReply:(CDUnknownBlockType)arg1;
- (void)startHIDEventRecordingWithReply:(CDUnknownBlockType)arg1;
@property(readonly) _Bool supportsHIDEventRecording;
- (void)_XCT_receivedSignpost:(id)arg1 withToken:(id)arg2;
- (void)unregisterForSignpostsWithToken:(id)arg1;
- (void)registerForSignpostsFromSubsystem:(id)arg1 category:(id)arg2 intervalTimeout:(double)arg3 reply:(CDUnknownBlockType)arg4;
@property(readonly) _Bool supportsSignpostListening;
- (void)postTelemetryData:(id)arg1 reply:(CDUnknownBlockType)arg2;
@property(readonly) _Bool supportsPostingTelemetryData;
- (void)enableFauxCollectionViewCells:(CDUnknownBlockType)arg1;
- (void)setLocalizableStringsDataGatheringEnabled:(_Bool)arg1 reply:(CDUnknownBlockType)arg2;
- (void)unloadAccessibility:(CDUnknownBlockType)arg1;
- (void)loadAccessibilityWithTimeout:(double)arg1 reply:(CDUnknownBlockType)arg2;
- (void)setAXTimeout:(double)arg1 reply:(CDUnknownBlockType)arg2;
- (id)synthesizeEvent:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestElementAtPoint:(struct CGPoint)arg1 reply:(CDUnknownBlockType)arg2;
- (void)fetchParameterizedAttribute:(id)arg1 forElement:(id)arg2 parameter:(id)arg3 reply:(CDUnknownBlockType)arg4;
- (void)setAttribute:(id)arg1 value:(id)arg2 element:(id)arg3 reply:(CDUnknownBlockType)arg4;
- (void)fetchAttributes:(id)arg1 forElement:(id)arg2 reply:(CDUnknownBlockType)arg3;
- (void)runAccessibilityAuditForElement:(id)arg1 withConfiguration:(id)arg2 reply:(CDUnknownBlockType)arg3;
- (void)fetchSnapshotForElement:(id)arg1 attributes:(id)arg2 parameters:(id)arg3 reply:(CDUnknownBlockType)arg4;
- (void)requestSnapshotForElement:(id)arg1 attributes:(id)arg2 parameters:(id)arg3 reply:(CDUnknownBlockType)arg4;
- (void)snapshotForElement:(id)arg1 attributes:(id)arg2 parameters:(id)arg3 reply:(CDUnknownBlockType)arg4;
@property(readonly) _Bool axNotificationsIncludeElement;
@property(readonly) _Bool useLegacySnapshotPath;
- (void)performAccessibilityAction:(id)arg1 onElement:(id)arg2 value:(id)arg3 reply:(CDUnknownBlockType)arg4;
- (void)unregisterForAccessibilityNotification:(int)arg1 registrationToken:(id)arg2 reply:(CDUnknownBlockType)arg3;
- (void)registerForAccessibilityNotification:(int)arg1 reply:(CDUnknownBlockType)arg2;
- (void)requestSpindumpWithSpecification:(id)arg1 completion:(CDUnknownBlockType)arg2;
@property double implicitEventConfirmationIntervalForCurrentContext; // @synthesize implicitEventConfirmationIntervalForCurrentContext=_implicitEventConfirmationIntervalForCurrentContext;
- (void)requestBackgroundAssertionForPID:(int)arg1 reply:(CDUnknownBlockType)arg2;
- (void)requestIDEConnectionTransportForSessionIdentifier:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)_XCT_receivedAccessibilityNotification:(int)arg1 fromElement:(id)arg2 payload:(id)arg3;
- (void)_XCT_receivedAccessibilityNotification:(int)arg1 withPayload:(id)arg2;
- (void)_XCT_applicationDidUpdateState:(id)arg1;
- (void)_XCT_applicationWithBundleID:(id)arg1 didUpdatePID:(int)arg2 andState:(unsigned long long)arg3;
@property(readonly) _Bool usePointTransformationsForFrameConversions;
@property(readonly) _Bool useLegacyEventCoordinateTransformationPath;
- (_Bool)requestPressureEventsSupportedOrError:(id *)arg1;
- (_Bool)requestPointerEventsSupportedOrError:(id *)arg1;
@property(readonly) id <XCTMessagingChannel_RunnerToDaemon> daemonProxy;
- (void)unregisterInvalidationHandlerWithToken:(id)arg1;
- (id)registerInvalidationHandler:(CDUnknownBlockType)arg1;
- (void)_reportInvalidation;
- (id)initWithConnection:(id)arg1 remoteInterfaceCapabilities:(id)arg2;
- (void)dealloc;
- (_Bool)resetAuthorizationStatusForBundleIdentifier:(id)arg1 resourceIdentifier:(id)arg2 error:(id *)arg3;
- (_Bool)enableAutomationModeWithError:(id *)arg1;
@property(readonly) _Bool supportsAutomationMode;
@property(readonly) _Bool supportsInjectingVoiceRecognitionAudioInputPaths;
- (void)injectVoiceRecognitionAudioInputPaths:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)injectAssistantRecognitionStrings:(id)arg1 completion:(CDUnknownBlockType)arg2;
@property(readonly) _Bool supportsStartingSiriUIRequestWithAudioFileURL;
- (void)startSiriUIRequestWithAudioFileURL:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)startSiriUIRequestWithText:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestSiriEnabledStatus:(CDUnknownBlockType)arg1;
- (void)requestScreenshotOfScreenWithID:(long long)arg1 withRect:(struct CGRect)arg2 encoding:(id)arg3 withReply:(CDUnknownBlockType)arg4;
@property(readonly, nonatomic) _Bool supportsHEICImageEncoding;
@property(readonly, nonatomic) _Bool useLegacyScreenshotPath;
- (void)requestUnsupportedBundleIdentifiersForAutomationSessions:(CDUnknownBlockType)arg1;
- (void)requestAutomationSessionForTestTargetWithPID:(int)arg1 preferredBackendPath:(id)arg2 reply:(CDUnknownBlockType)arg3;
@property(readonly) long long applicationAutomationSessionSupport;
- (void)updateAppearanceMode:(long long)arg1 completion:(CDUnknownBlockType)arg2;
- (void)getAppearanceModeWithReply:(CDUnknownBlockType)arg1;
@property(readonly) _Bool supportsAppearanceMode;
- (void)updateDeviceOrientation:(long long)arg1 completion:(CDUnknownBlockType)arg2;
- (void)performDeviceEvent:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)getDeviceOrientationWithCompletion:(CDUnknownBlockType)arg1;
- (void)requestApplicationSpecifierForPID:(int)arg1 reply:(CDUnknownBlockType)arg2;
- (void)fetchAttributesForElement:(id)arg1 attributes:(id)arg2 reply:(CDUnknownBlockType)arg3;
- (void)terminateApplicationWithBundleID:(id)arg1 pid:(int)arg2 completion:(CDUnknownBlockType)arg3;
- (void)launchApplicationWithPath:(id)arg1 bundleID:(id)arg2 arguments:(id)arg3 environment:(id)arg4 completion:(CDUnknownBlockType)arg5;
- (void)beginMonitoringApplicationWithSpecifier:(id)arg1;

// Remaining properties

@end

#endif