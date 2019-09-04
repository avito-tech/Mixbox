public final class RunLoopSpinningWaiterImpl: RunLoopSpinningWaiter {
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(runLoopSpinnerFactory: RunLoopSpinnerFactory) {
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    @discardableResult
    public func wait(
        timeout: TimeInterval,
        interval: TimeInterval,
        until stopCondition: @escaping () -> (Bool))
        -> SpinUntilResult
    {
        let runLoopSpinner = runLoopSpinnerFactory.runLoopSpinner(
            timeout: timeout,
            maxSleepInterval: interval
        )
        
        return runLoopSpinner.spinUntil(stopCondition: stopCondition)
    }
}
