#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
