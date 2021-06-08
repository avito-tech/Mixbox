public protocol ZeroToleranceTimerScheduler: AnyObject {
    func schedule(
        interval: TimeInterval,
        target: ZeroToleranceTimerTarget)
        -> ScheduledZeroToleranceTimer
}
