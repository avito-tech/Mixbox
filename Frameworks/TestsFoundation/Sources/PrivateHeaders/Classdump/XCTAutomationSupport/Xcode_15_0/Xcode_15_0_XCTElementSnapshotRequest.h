#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@protocol XCTAccessibilityFramework, XCTMacCatalystStatusProviding;

@class XCAXCycleDetector, XCAccessibilityElement, XCElementSnapshot, XCTAccessibilitySnapshot_iOS, XCTTimeoutControls;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTElementSnapshotRequest : NSObject
{
    _Bool _preserveRemoteElementPlaceholders;
    _Bool _loadResult;
    _Bool _hasLoaded;
    id <XCTAccessibilityFramework> _accessibilityFramework;
    XCAccessibilityElement *_element;
    NSArray *_attributes;
    NSDictionary *_parameters;
    XCElementSnapshot *_elementSnapshot;
    id <NSCopying> _accessibilitySnapshot;
    XCTTimeoutControls *_timeoutControls;
    XCAXCycleDetector *_cycleDetector;
    id <XCTMacCatalystStatusProviding> _macCatalystStatusProvider;
    NSObject *_queue;
    NSError *_loadError;
}

@property(retain) NSError *loadError; // @synthesize loadError=_loadError;
@property _Bool hasLoaded; // @synthesize hasLoaded=_hasLoaded;
@property _Bool loadResult; // @synthesize loadResult=_loadResult;
@property(readonly) NSObject *queue; // @synthesize queue=_queue;
@property _Bool preserveRemoteElementPlaceholders; // @synthesize preserveRemoteElementPlaceholders=_preserveRemoteElementPlaceholders;
@property(retain) id <XCTMacCatalystStatusProviding> macCatalystStatusProvider; // @synthesize macCatalystStatusProvider=_macCatalystStatusProvider;
@property(retain) XCAXCycleDetector *cycleDetector; // @synthesize cycleDetector=_cycleDetector;
@property(readonly) XCTTimeoutControls *timeoutControls; // @synthesize timeoutControls=_timeoutControls;
@property(copy) id <NSCopying> accessibilitySnapshot; // @synthesize accessibilitySnapshot=_accessibilitySnapshot;
@property(retain) XCElementSnapshot *elementSnapshot; // @synthesize elementSnapshot=_elementSnapshot;
@property(copy) NSDictionary *parameters; // @synthesize parameters=_parameters;
@property(readonly) NSArray *attributes; // @synthesize attributes=_attributes;
@property(readonly) XCAccessibilityElement *element; // @synthesize element=_element;
@property(readonly) id <XCTAccessibilityFramework> accessibilityFramework; // @synthesize accessibilityFramework=_accessibilityFramework;
- (_Bool)loadSnapshotAndReturnError:(id *)arg1;
- (id)initWithAccessibilityFramework:(id)arg1 element:(id)arg2 attributes:(id)arg3 parameters:(id)arg4 timeoutControls:(id)arg5;
- (id)initWithAccessibilityFramework:(id)arg1 element:(id)arg2 attributes:(id)arg3 parameters:(id)arg4;
- (id)elementSnapshotOrError:(id *)arg1;
- (id)accessibilitySnapshotOrError:(id *)arg1;
- (id)safeParametersForParameters:(id)arg1;
- (id)_snapshotFromUserTestingSnapshot:(id)arg1 frameTransformer:(CDUnknownBlockType)arg2 error:(id *)arg3;
- (id)_childrenOfElement:(id)arg1 userTestingSnapshot:(id)arg2 frameTransformer:(CDUnknownBlockType)arg3 outError:(id *)arg4;
- (id)_snapshotFromRemoteElementUserTestingSnapshot:(id)arg1 parentElement:(id)arg2 error:(id *)arg3;
@property(readonly) XCTAccessibilitySnapshot_iOS *accessibilitySnapshot_iOS;

@end

#endif