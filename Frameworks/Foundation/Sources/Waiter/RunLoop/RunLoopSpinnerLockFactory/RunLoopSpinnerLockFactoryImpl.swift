#if MIXBOX_ENABLE_IN_APP_SERVICES

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
