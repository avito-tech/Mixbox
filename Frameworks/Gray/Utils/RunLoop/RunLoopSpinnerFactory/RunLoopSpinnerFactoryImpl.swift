public final class RunLoopSpinnerFactoryImpl: RunLoopSpinnerFactory {
    private let runLoopModesStackProvider: RunLoopModesStackProvider
    
    public init(
        runLoopModesStackProvider: RunLoopModesStackProvider)
    {
        self.runLoopModesStackProvider = runLoopModesStackProvider
    }
    
    public func spinnerImpl(
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
