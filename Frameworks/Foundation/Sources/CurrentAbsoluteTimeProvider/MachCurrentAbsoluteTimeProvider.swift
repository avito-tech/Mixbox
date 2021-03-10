#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class MachCurrentAbsoluteTimeProvider: CurrentAbsoluteTimeProvider {
    public init() {
    }
    
    public func currentAbsoluteTime() -> AbsoluteTime {
        return AbsoluteTime(
            machAbsoluteTime: mach_absolute_time()
        )
    }
}

#endif
