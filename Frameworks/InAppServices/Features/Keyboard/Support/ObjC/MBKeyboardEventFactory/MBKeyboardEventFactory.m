#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "MBKeyboardEventFactory.h"

#include <mach/mach_time.h>

typedef uint32_t IOHIDEventOptionBits;

IOHIDEventRef IOHIDEventCreateKeyboardEvent(
                                            CFAllocatorRef allocator,
                                            AbsoluteTime timeStamp,
                                            uint16_t usagePage,
                                            uint16_t usage,
                                            Boolean down,
                                            IOHIDEventOptionBits flags);

@implementation MBKeyboardEventFactory

- (AbsoluteTime)currentTime {
    uint64_t machAbsoluteTime = mach_absolute_time();
    AbsoluteTime timeStamp;
    timeStamp.hi = (UInt32)(machAbsoluteTime >> 32);
    timeStamp.lo = (UInt32)(machAbsoluteTime);
    return timeStamp;
}

- (IOHIDEventRef)eventWithTime:(AbsoluteTime)time usagePage:(uint16_t)usagePage usage:(uint16_t)usage down:(BOOL)down {
    IOHIDEventRef hidEvent = IOHIDEventCreateKeyboardEvent(
                                                           kCFAllocatorDefault,
                                                           time,
                                                           usagePage,
                                                           usage,
                                                           down,
                                                           1);
    return hidEvent;
}

@end

#endif
