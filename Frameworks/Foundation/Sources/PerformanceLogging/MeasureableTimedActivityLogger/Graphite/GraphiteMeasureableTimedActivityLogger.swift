#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class GraphiteMeasureableTimedActivityLogger: MeasureableTimedActivityLogger {
    private let graphiteMeasureableTimedActivityMetricSender: GraphiteMeasureableTimedActivityMetricSender
    private let dateProvider: DateProvider
    private let dispatchQueue: DispatchQueue
    
    public init(
        graphiteMeasureableTimedActivityMetricSender: GraphiteMeasureableTimedActivityMetricSender,
        dateProvider: DateProvider)
    {
        self.graphiteMeasureableTimedActivityMetricSender = graphiteMeasureableTimedActivityMetricSender
        self.dateProvider = dateProvider
        self.dispatchQueue = DispatchQueue.global(qos: .background)
    }
    
    public func start(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?))
         -> MeasureableTimedActivity
    {
        let startDate = dateProvider.currentDate()
        
        return GraphiteMeasureableTimedActivity(
            graphiteMeasureableTimedActivityMetricSender: graphiteMeasureableTimedActivityMetricSender,
            dateProvider: dateProvider,
            staticName: staticName,
            dynamicName: dynamicName,
            startDate: startDate
        )
    }
}

#endif
