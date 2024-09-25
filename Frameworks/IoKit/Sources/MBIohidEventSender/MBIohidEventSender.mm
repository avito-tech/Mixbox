#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

#import "MBIohidEventSender.h"

#if SWIFT_PACKAGE
#import "../SoftLinking/SoftLinking.h"
#import "../PrivateApi/IOKit/hid/IOHIDEventSystemClient.h"
static AbsoluteTime mixbox_absoluteTimeFromUInt32(UInt32 hi, UInt32 lo) {
    AbsoluteTime absoluteTime;
    absoluteTime.hi = hi;
    absoluteTime.lo = lo;
    return absoluteTime;
}

static AbsoluteTime mixbox_absoluteTimeFromUInt64(UInt64 time) {
    UInt32 hi = time >> sizeof(UInt32) * CHAR_BIT;
    UInt32 lo = time & UINT32_MAX;
    
    return mixbox_absoluteTimeFromUInt32(hi, lo);
}
#else
#import "SoftLinking.h"
#import "IOHIDEventSystemClient.h"
#import <MixboxFoundation/AbsoluteTime.h>
#endif

#include <mach/mach_time.h>

// The code is based on:
// https://github.com/qtwebkit/webkit-mirror/blob/0ef1a89b0d1f7fd94cf17b8fba3876e5ec301374/Tools/WebKitTestRunner/ios/HIDEventGenerator.mm

@interface UIApplication ()
- (void)_enqueueHIDEvent:(IOHIDEventRef)event;
@end

@interface UIWindow ()
- (uint32_t)_contextId;
@end

SOFT_LINK_PRIVATE_FRAMEWORK(BackBoardServices);
SOFT_LINK(
          BackBoardServices,
          BKSHIDEventSetDigitizerInfo,
          void,
          (
           IOHIDEventRef digitizerEvent,
           uint32_t contextID,
           uint8_t systemGestureisPossible,
           uint8_t isSystemGestureStateChangeEvent,
           CFStringRef displayUUID,
           CFTimeInterval initialTouchTimestamp,
           float maxForce
           ),
          (
           digitizerEvent,
           contextID,
           systemGestureisPossible,
           isSystemGestureStateChangeEvent,
           displayUUID,
           initialTouchTimestamp,
           maxForce
           )
          );

@implementation MBIohidEventSender {
    IOHIDEventSystemClientRef ioSystemClient;
    CFIndex lastEventCallbackIndex;
    NSMutableDictionary *eventCallbacks;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        eventCallbacks = [NSMutableDictionary new];
    }
    return self;
}

- (nullable NSString *)sendEvent:(nonnull IOHIDEventRef)event
                     application:(nonnull UIApplication *)application
{
    if (!ioSystemClient) {
        // NOTE: I have no idea why this code is used in `HIDEventGenerator.mm` in https://github.com/qtwebkit/webkit-mirror.
        // The client is only created and not used. Injecting keyboard events works perfectly fine without it.
        // This code can be removed, but I don't know what will happen. In fact `HIDEventGenerator.mm` works fine,
        // so maybe this code really do something, I don't know.
        ioSystemClient = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    }
    
    uint32_t contextId = application.keyWindow._contextId;
    
    if (contextId) {
        // Without the following line sent events were ignored by UIKit. It is very important.
        BKSHIDEventSetDigitizerInfo(event, contextId, false, false, NULL, 0, 0);
        [application _enqueueHIDEvent:event];
        
        return nil;
    } else {
        return [self unexpectedZeroContextIdErrorMessage];
    }
}

- (void)waitForEventsBeingSentToApplication:(nonnull UIApplication *)application
                            completionBlock:(nonnull void (^)(NSString * __nullable))completionBlock
{
    CFIndex callbackIndex = [self nextEventCallbackIndex];
    NSNumber *callbackIndexKey = @(callbackIndex);
    
    void (^voidCompletionBlock)() = ^{
        completionBlock(nil);
    };
    
    [eventCallbacks setObject:[voidCompletionBlock copy] forKey:callbackIndexKey];
    
    uint32_t kHIDPage_VendorDefinedStart = 0xFF00;
    uint32_t kIOHIDEventOptionNone = 0;
    IOHIDEventRef markerEvent = IOHIDEventCreateVendorDefinedEvent(
                                                          kCFAllocatorDefault,
                                                          mixbox_absoluteTimeFromUInt64(mach_absolute_time()),
                                                          kHIDPage_VendorDefinedStart + 100,
                                                          0,
                                                          1,
                                                          (uint8_t*)&callbackIndex,
                                                          sizeof(CFIndex),
                                                          kIOHIDEventOptionNone
                                                          );
    
    if (markerEvent) {
        auto contextId = application.keyWindow._contextId;
        
        if (contextId) {
            BKSHIDEventSetDigitizerInfo(markerEvent, contextId, false, false, NULL, 0, 0);
            [application _enqueueHIDEvent:markerEvent];
        } else {
            completionBlock([self unexpectedZeroContextIdErrorMessage]);
        }
    } else {
        completionBlock(@"Error: failed to IOHIDEventCreateVendorDefinedEvent. Function returned nil.");
    }
}

// Note: translates to Swift as `func handle(_:)`
- (void)handleIohidEvent:(nonnull IOHIDEventRef)event {
    if (IOHIDEventGetType(event) == kIOHIDEventTypeVendorDefined) {
        CFIndex callbackIndex = IOHIDEventGetIntegerValue(event, kIOHIDEventFieldVendorDefinedData);
        NSNumber *callbackIndexKey = @(callbackIndex);
        
        void (^completionBlock)() = [self->eventCallbacks objectForKey:callbackIndexKey];
        
        if (completionBlock) {
            completionBlock();
            
            [self->eventCallbacks removeObjectForKey:callbackIndexKey];
        }
    }
}

- (CFIndex)nextEventCallbackIndex {
    lastEventCallbackIndex += 1;
    return lastEventCallbackIndex;
}

- (NSString *)unexpectedZeroContextIdErrorMessage {
    return @"application.keyWindow._contextId is 0, which is not expected";
}

@end

#endif
