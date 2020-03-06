#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class MachCurrentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider {
    public init() {
    }
    
    public func currentAbsoluteTime() -> AbsoluteTime {
        let machAbsoluteTime = mach_absolute_time()
        
        return AbsoluteTime(
            hi: UInt32(machAbsoluteTime >> UInt32.bitWidth),
            lo: UInt32(machAbsoluteTime & UInt64(UInt32.max))
        )
    }
}

#endif
