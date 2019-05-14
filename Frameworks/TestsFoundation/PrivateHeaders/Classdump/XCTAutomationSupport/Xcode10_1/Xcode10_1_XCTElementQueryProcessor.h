#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120100 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120200

#import "Xcode10_1_XCTAutomationSupport_CDStructures.h"
#import "Xcode10_1_SharedHeader.h"
#import "Xcode10_1_XCTElementSnapshotAttributeDataSource.h"
#import "Xcode10_1_XCTElementSnapshotProvider.h"
#import <Foundation/Foundation.h>

@protocol XCTElementSnapshotProvider;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTElementQueryProcessor : NSObject <XCTElementSnapshotProvider, XCTElementSnapshotAttributeDataSource>
{
    id <XCTElementSnapshotProvider> _snapshotProvider;
}

@property __weak id <XCTElementSnapshotProvider> snapshotProvider; // @synthesize snapshotProvider=_snapshotProvider;
@property(readonly) _Bool usePointTransformationsForFrameConversions;
@property(readonly) _Bool supportsHostedViewCoordinateTransformations;
- (id)parameterizedAttribute:(id)arg1 forElement:(id)arg2 parameter:(id)arg3 error:(id *)arg4;
- (id)attributesForElement:(id)arg1 attributes:(id)arg2 error:(id *)arg3;
@property(readonly) _Bool allowsRemoteAccess;
- (id)snapshotForElement:(id)arg1 attributes:(id)arg2 parameters:(id)arg3 error:(id *)arg4;
- (void)fetchMatchesForQuery:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (id)init;

// Remaining properties

@end

#endif