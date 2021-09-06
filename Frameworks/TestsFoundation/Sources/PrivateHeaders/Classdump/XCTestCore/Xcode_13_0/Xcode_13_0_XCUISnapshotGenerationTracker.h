#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 160000

#import "Xcode_13_0_XCTestCore_CDStructures.h"
#import "Xcode_13_0_SharedHeader.h"
#import <Foundation/Foundation.h>

@class CFRunLoopObserver;

//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

__attribute__((visibility("hidden")))
@interface XCUISnapshotGenerationTracker : NSObject
{
    struct __CFRunLoopObserver *_generationObserver;
    unsigned long long _generation;
}

+ (unsigned long long)generation;
+ (instancetype)sharedTracker;
- (id)_init;
- (void)dealloc;

@end

#endif