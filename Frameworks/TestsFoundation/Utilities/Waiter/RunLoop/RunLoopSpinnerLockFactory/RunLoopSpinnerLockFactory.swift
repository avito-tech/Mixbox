public protocol RunLoopSpinnerLockFactory: class {
    func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock
}
