#if MIXBOX_ENABLE_IN_APP_SERVICES

import os

public final class GraphiteMeasureableTimedActivity: MeasureableTimedActivity {
    private let graphiteMeasureableTimedActivityMetricSender: GraphiteMeasureableTimedActivityMetricSender
    private let dateProvider: DateProvider
    private let staticName: StaticString
    private let dynamicName: () -> (String?)
    private let startDate: Date
    
    public init(
        graphiteMeasureableTimedActivityMetricSender: GraphiteMeasureableTimedActivityMetricSender,
        dateProvider: DateProvider,
        staticName: StaticString,
        dynamicName: @escaping () -> (String?),
        startDate: Date)
    {
        self.graphiteMeasureableTimedActivityMetricSender = graphiteMeasureableTimedActivityMetricSender
        self.dateProvider = dateProvider
        self.staticName = staticName
        self.dynamicName = dynamicName
        self.startDate = startDate
    }
    
    public func stop() {
        let stopDate = dateProvider.currentDate()
        
        graphiteMeasureableTimedActivityMetricSender.send(
            staticName: staticName,
            dynamicName: dynamicName,
            startDate: startDate,
            stopDate: stopDate
        )
    }
}

#endif
