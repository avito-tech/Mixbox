#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Darwin

public final class AbsoluteTime: Equatable {
    public let lo: UInt32
    public let hi: UInt32
    
    public var darwinAbsoluteTime: Darwin.AbsoluteTime {
        return Darwin.AbsoluteTime(lo: lo, hi: hi)
    }
    
    public init(lo: UInt32, hi: UInt32) {
        self.hi = hi
        self.lo = lo
    }
    
    public convenience init(darwinAbsoluteTime: Darwin.AbsoluteTime) {
        self.init(
            lo: darwinAbsoluteTime.lo,
            hi: darwinAbsoluteTime.hi
        )
    }
    
    public convenience init(machAbsoluteTime: UInt64) {
        self.init(
            lo: UInt32(machAbsoluteTime & UInt64(UInt32.max)),
            hi: UInt32(machAbsoluteTime >> UInt32.bitWidth)
        )    
    }
    
    public static func ==(lhs: AbsoluteTime, rhs: AbsoluteTime) -> Bool {
        return lhs.hi == rhs.hi && lhs.lo == rhs.lo
    }
}

#endif
