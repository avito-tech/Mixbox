#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 180000

#import "Xcode_15_0_XCTestCore_CDStructures.h"
#import "Xcode_15_0_SharedHeader.h"
#import "Xcode_15_0_XCTestExpectationDelegate.h"
#import <Foundation/Foundation.h>

@class CFRunLoop;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

@interface XCTWaiterWait : NSObject <XCTestExpectationDelegate>
{
    struct __CFRunLoop *_runLoop;
    unsigned int _result:4;
    unsigned int _stalled:1;
    _Bool _enforceOrder;
    _Bool _synchronous;
    NSArray *_expectations;
    double _timeout;
    NSArray *_callStackReturnAddressesOfCaller;
    unsigned long long _threadIDOfCaller;
}

- (void)didFulfillExpectation:(id)arg1;
- (id)initWithExpectations:(id)arg1 timeout:(double)arg2 enforceOrder:(_Bool)arg3 isSynchronous:(_Bool)arg4;

// Remaining properties

@end

#endif