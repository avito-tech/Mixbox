#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class RunLoopSpinnerFactoryImpl: RunLoopSpinnerFactory {
    private let runLoopModesStackProvider: RunLoopModesStackProvider
    
    public init(
        runLoopModesStackProvider: RunLoopModesStackProvider)
    {
        self.runLoopModesStackProvider = runLoopModesStackProvider
    }
    
    public func runLoopSpinnerImpl(
        timeout: TimeInterval,
        minRunLoopDrains: Int,
        maxSleepInterval: TimeInterval,
        conditionMetHandler: @escaping () -> ())
        -> RunLoopSpinner
    {
        return RunLoopSpinnerImpl(
            timeout: timeout,
            minRunLoopDrains: minRunLoopDrains,
            maxSleepInterval: maxSleepInterval,
            runLoopModesStackProvider: runLoopModesStackProvider,
            conditionMetHandler: conditionMetHandler
        )
    }
}

#endif
