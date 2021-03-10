#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class SystemClockDateProvider: DateProvider {
    public init() {
    }
    
    public func currentDate() -> Date {
        return Date()
    }
}

#endif
