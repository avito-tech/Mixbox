#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol GraphiteMeasureableTimedActivityMetricSender {
    func send(
        staticName: StaticString,
        dynamicName: @escaping () -> (String?),
        startDate: Date,
        stopDate: Date
    )
}

#endif
