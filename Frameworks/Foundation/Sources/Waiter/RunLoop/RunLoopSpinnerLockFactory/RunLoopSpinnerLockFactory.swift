#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol RunLoopSpinnerLockFactory: AnyObject {
    func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock
}

#endif
