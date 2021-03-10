#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol RunLoopSpinnerLockFactory: class {
    func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock
}

#endif
