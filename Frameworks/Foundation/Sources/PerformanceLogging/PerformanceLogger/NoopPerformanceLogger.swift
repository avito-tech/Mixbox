#if MIXBOX_ENABLE_IN_APP_SERVICES

// To disable logging via DI
public final class NoopPerformanceLogger: PerformanceLogger {
    public init() {
    }
    
    public func startImpl(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?),
        destinations: Set<PerformanceLoggerDestination>)
        -> MeasureableTimedActivity
    {
        // Do nothing, logging is disabled
        
        return NoopMeasureableTimedActivity()
    }
}

#endif
