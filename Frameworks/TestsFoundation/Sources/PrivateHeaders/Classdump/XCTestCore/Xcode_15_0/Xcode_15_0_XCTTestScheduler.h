#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"

@protocol XCTTestSchedulerDelegate, XCTTestSchedulerWorker;

@class XCTTestIdentifierSet;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTTestScheduler
@property(retain) NSObject *delegateQueue;
@property __weak id <XCTTestSchedulerDelegate> delegate;
@property(retain) NSObject *workerQueue;
- (void)startWithTestIdentifiersToRun:(XCTTestIdentifierSet *)arg1 testIdentifiersToSkip:(XCTTestIdentifierSet *)arg2;
- (void)workerDidBecomeAvailable:(id <XCTTestSchedulerWorker>)arg1;
@end

#endif
