#if MIXBOX_ENABLE_IN_APP_SERVICES

// To disable logging via DI
public final class NoopMeasureableTimedActivityLogger: MeasureableTimedActivityLogger {
    public init() {
    }
    
    public func start(
        staticName: StaticString,
        dynamicName: () -> (String?))
        -> MeasureableTimedActivity
    {
        // Do nothing, logging is disabled
        
        return NoopMeasureableTimedActivity()
    }
}

#endif
