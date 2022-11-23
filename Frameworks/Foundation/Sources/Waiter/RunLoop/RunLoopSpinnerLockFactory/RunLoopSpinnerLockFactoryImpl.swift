#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class RunLoopSpinnerLockFactoryImpl: RunLoopSpinnerLockFactory {
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(runLoopSpinnerFactory: RunLoopSpinnerFactory) {
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    public func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock {
        return RunLoopSpinnerLockImpl(
            runLoopSpinnerFactory: runLoopSpinnerFactory,
            pollingInterval: pollingInterval
        )
    }
}

#endif
