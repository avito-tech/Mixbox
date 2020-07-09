#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class NoopMeasureableTimedActivityMetricSenderWaiter:
    MeasureableTimedActivityMetricSenderWaiter
{
    public init() {
    }
    
    public func waitForAllMetricsAreSent() {
    }
}

#endif
