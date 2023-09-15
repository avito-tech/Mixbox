#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@protocol XCTTestWorker;

@class XCTRunnerIDESession;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@protocol XCTRunnerIDESessionDelegate <NSObject>
- (id <XCTTestWorker>)testWorkerForIDESession:(XCTRunnerIDESession *)arg1;
- (void)IDESessionDidDisconnect:(XCTRunnerIDESession *)arg1;
@end

#endif
