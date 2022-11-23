#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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

#endif
