#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#ifndef mixbox_absoluteTime_h
#define mixbox_absoluteTime_h

#include <stdint.h>
#include <limits.h>

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
