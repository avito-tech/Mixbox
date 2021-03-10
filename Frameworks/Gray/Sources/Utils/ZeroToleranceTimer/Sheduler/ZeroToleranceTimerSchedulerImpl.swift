public final class ZeroToleranceTimerSchedulerImpl: ZeroToleranceTimerScheduler {
    public init() {
    }
    
    public func schedule(
        interval: TimeInterval,
        target: ZeroToleranceTimerTarget)
        -> ScheduledZeroToleranceTimer
    {
        let timer = scheduleZeroToleranceDispatchSourceTimer(
            interval: interval,
            handler: {
                target.timerFired()
            }
        )
        
        let activityId = ProcessInfo.processInfo.beginActivity(
            options: .latencyCritical,
            reason: "Using high-precision timer."
        )
        
        return ScheduledZeroToleranceTimerImpl(
            scheduleZeroToleranceDispatchSourceTimer: timer,
            activityId: activityId
        )
    }
    
    func scheduleZeroToleranceDispatchSourceTimer(
        interval: TimeInterval,
        handler: @escaping () -> Void)
        -> DispatchSourceTimer
    {
        let timerSource = DispatchSource.makeTimerSource(queue: .main)
        
        timerSource.schedule(
            deadline: .now() + interval,
            repeating: DispatchTimeInterval.nanoseconds(
                Int(interval * Double(NSEC_PER_SEC))
            ),
            leeway: DispatchTimeInterval.seconds(0)
        )
        
        timerSource.setEventHandler(handler: handler)
        timerSource.resume()
        
        return timerSource
    }
}
