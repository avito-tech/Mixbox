#if MIXBOX_ENABLE_IN_APP_SERVICES

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
