public protocol RunLoopSpinnerFactory {
    func spinnerImpl(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval,
        conditionMetHandler: @escaping () -> ())
        -> RunLoopSpinner
}

extension RunLoopSpinnerFactory {
    public func spinner(
        timeout: TimeInterval,
        minRunLoopDrains: Int = 0,
        maxSleepInterval: TimeInterval = .greatestFiniteMagnitude,
        conditionMetHandler: @escaping () -> () = {})
        -> RunLoopSpinner
    {
        return spinnerImpl(
            timeout: timeout,
            minRunLoopDrains: minRunLoopDrains,
            maxSleepInterval: maxSleepInterval,
            conditionMetHandler: conditionMetHandler
        )
    }
}
