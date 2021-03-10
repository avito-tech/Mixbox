#if MIXBOX_ENABLE_IN_APP_SERVICES

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
