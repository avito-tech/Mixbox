#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTAutomationSupport_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@protocol XCTElementSnapshotProvider;

@class XCTCapabilities;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTElementQueryProcessor : NSObject
{
    id <XCTElementSnapshotProvider> _dataSource;
    XCTCapabilities *_remoteInterfaceCapabilities;
}

@property(retain) XCTCapabilities *remoteInterfaceCapabilities; // @synthesize remoteInterfaceCapabilities=_remoteInterfaceCapabilities;
@property(readonly) __weak id <XCTElementSnapshotProvider> dataSource; // @synthesize dataSource=_dataSource;
- (void)fetchMatchesForQuery:(id)arg1 clientCapabilities:(id)arg2 reply:(CDUnknownBlockType)arg3;
- (id)initWithDataSource:(id)arg1;

@end

#endif