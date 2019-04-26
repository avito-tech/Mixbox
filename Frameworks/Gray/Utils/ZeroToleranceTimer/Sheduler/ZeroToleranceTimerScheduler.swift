public protocol ZeroToleranceTimerScheduler {
    func schedule(
        interval: TimeInterval,
        target: ZeroToleranceTimerTarget)
        -> ScheduledZeroToleranceTimer
}
