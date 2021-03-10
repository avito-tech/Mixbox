public protocol ZeroToleranceTimerScheduler: class {
    func schedule(
        interval: TimeInterval,
        target: ZeroToleranceTimerTarget)
        -> ScheduledZeroToleranceTimer
}
