public final class SpinnerImpl: Spinner {
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(runLoopSpinnerFactory: RunLoopSpinnerFactory) {
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    @discardableResult
    public func spin(
        timeout: TimeInterval,
        interval: TimeInterval,
        until stopCondition: @escaping () -> (Bool))
        -> SpinUntilResult
    {
        let spinner = runLoopSpinnerFactory.spinner(
            timeout: timeout,
            maxSleepInterval: interval
        )
        
        return spinner.spinUntil(stopCondition: stopCondition)
    }
}
