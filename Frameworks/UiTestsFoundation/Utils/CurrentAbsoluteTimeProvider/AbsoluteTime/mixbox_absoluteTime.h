#ifndef mixbox_absoluteTime_h
#define mixbox_absoluteTime_h

static AbsoluteTime mixbox_absoluteTime(UInt32 hi, UInt32 lo) {
    AbsoluteTime absoluteTime;
    absoluteTime.hi = hi;
    absoluteTime.lo = lo;
    return absoluteTime;
}

#endif /* mixbox_absoluteTime_h */
