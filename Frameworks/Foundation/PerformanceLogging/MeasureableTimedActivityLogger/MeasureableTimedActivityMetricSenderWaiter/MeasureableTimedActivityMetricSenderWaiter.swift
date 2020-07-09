#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol MeasureableTimedActivityMetricSenderWaiter {
    func waitForAllMetricsAreSent()
}

#endif
