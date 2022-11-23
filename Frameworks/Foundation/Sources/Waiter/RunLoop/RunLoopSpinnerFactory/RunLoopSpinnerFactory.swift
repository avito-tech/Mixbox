#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public protocol RunLoopSpinnerFactory: AnyObject {
    func runLoopSpinnerImpl(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval,
        conditionMetHandler: @escaping () -> ())
        -> RunLoopSpinner
}

extension RunLoopSpinnerFactory {
    public func runLoopSpinner(
        timeout: TimeInterval,
        // The default value is 2 because, as per the CFRunLoop implementation, some ports
        // (specifically the dispatch port) will only be serviced every other run loop drain.
        minRunLoopDrains: Int = 2,
        maxSleepInterval: TimeInterval = .greatestFiniteMagnitude,
        conditionMetHandler: @escaping () -> () = {})
        -> RunLoopSpinner
    {
        return runLoopSpinnerImpl(
            timeout: timeout,
            minRunLoopDrains: minRunLoopDrains,
            maxSleepInterval: maxSleepInterval,
            conditionMetHandler: conditionMetHandler
        )
    }
}

#endif
