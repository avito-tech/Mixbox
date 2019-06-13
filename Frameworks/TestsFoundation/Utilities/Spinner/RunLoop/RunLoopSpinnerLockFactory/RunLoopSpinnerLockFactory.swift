public protocol RunLoopSpinnerLockFactory {
    func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock
}
