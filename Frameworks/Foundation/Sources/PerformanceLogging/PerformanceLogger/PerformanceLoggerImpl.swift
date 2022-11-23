#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class PerformanceLoggerImpl: PerformanceLogger {
    public let signpostMeasureableTimedActivityLogger: MeasureableTimedActivityLogger
    public let graphiteMeasureableTimedActivityLogger: MeasureableTimedActivityLogger
    
    public init(
        signpostMeasureableTimedActivityLogger: MeasureableTimedActivityLogger,
        graphiteMeasureableTimedActivityLogger: MeasureableTimedActivityLogger)
    {
        self.signpostMeasureableTimedActivityLogger = signpostMeasureableTimedActivityLogger
        self.graphiteMeasureableTimedActivityLogger = graphiteMeasureableTimedActivityLogger
    }
    
    public func startImpl(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?) = nilString,
        destinations: Set<PerformanceLoggerDestination> = PerformanceLoggerDestination.allDestinations)
        -> MeasureableTimedActivity
    {
        return CompoundMeasureableTimedActivity(
            activities: destinations.map { destination in
                let logger: MeasureableTimedActivityLogger
                
                switch destination {
                case .graphite:
                    logger = graphiteMeasureableTimedActivityLogger
                case .signpost:
                    logger = signpostMeasureableTimedActivityLogger
                }
                
                return logger.start(
                    staticName: staticName,
                    dynamicName: dynamicName
                )
            }
        )
    }
}

#endif
