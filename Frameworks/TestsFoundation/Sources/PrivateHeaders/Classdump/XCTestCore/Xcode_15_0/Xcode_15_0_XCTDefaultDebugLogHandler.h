#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCDebugLogDelegate.h"
#import "Xcode_15_0_XCTASDebugLogDelegate.h"
#import <Foundation/Foundation.h>

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTDefaultDebugLogHandler : NSObject <XCTASDebugLogDelegate, XCDebugLogDelegate>
{
    struct os_unfair_lock_s _lock;
    NSMutableArray *_logSinks;
    NSMutableArray *_debugMessageBuffer;
}

+ (instancetype)sharedHandler;
@property(readonly) NSMutableArray *debugMessageBuffer; // @synthesize debugMessageBuffer=_debugMessageBuffer;
- (void)logDebugMessage:(id)arg1;
- (void)removeLogSink:(id)arg1;
- (void)addLogSink:(id)arg1;
- (void)_locked_flushDebugMessageBufferWithBlock:(CDUnknownBlockType)arg1;
- (void)printBufferedDebugMessages;
- (void)logStartupInfo;
- (id)init;

// Remaining properties

@end

#endif