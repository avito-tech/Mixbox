public protocol RunLoopSpinnerFactory {
    func runLoopSpinner(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval,
        conditionMetHandler: @escaping () -> ())
        -> RunLoopSpinner
}

extension RunLoopSpinnerFactory {
    public func runLoopSpinner(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval)
        -> RunLoopSpinner
    {
        return runLoopSpinner(
            timeout: timeout,
            minRunLoopDrains: minRunLoopDrains,
            maxSleepInterval: maxSleepInterval,
            conditionMetHandler: {}
        )
    }
}
