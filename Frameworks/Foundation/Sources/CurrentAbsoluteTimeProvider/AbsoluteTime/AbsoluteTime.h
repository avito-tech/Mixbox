#if defined(MIXBOX_ENABLE_FRAMEWORK_FOUNDATION) && defined(MIXBOX_DISABLE_FRAMEWORK_FOUNDATION)
#error "Foundation is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_FOUNDATION) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_FOUNDATION))
// The compilation is disabled
#else

#ifndef mixbox_absoluteTime_h
#define mixbox_absoluteTime_h

#include <stdint.h>
#include <limits.h>
#include <MacTypes.h>

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

#endif /* mixbox_absoluteTime_h */

#endif
