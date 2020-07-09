#if MIXBOX_ENABLE_IN_APP_SERVICES

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
