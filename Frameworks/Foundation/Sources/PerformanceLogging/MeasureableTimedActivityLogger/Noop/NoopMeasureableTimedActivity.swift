#if MIXBOX_ENABLE_IN_APP_SERVICES

// To disable logging via DI, see NoopMeasureableTimedActivityLogger
public final class NoopMeasureableTimedActivity: MeasureableTimedActivity {
    public init() {
    }
    
    public func stop() {
        // Do nothing, logging is disabled
    }
}

#endif
