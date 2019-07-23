// Mimics DispatchGroup interface, but doesn't lock current thread.
// Instead it spins runloop. This may prevent deadlocks if completion of some action is scheduled on current thread
// and requires spinning runloop to be called.
//
// This class is thread safe.
//
public protocol RunLoopSpinnerLock: class {
    func enter()
    func leave() throws
    func wait(timeout: TimeInterval) -> RunLoopSpinnerLockWaitResult
}

extension RunLoopSpinnerLock {
    public func wait() {
        // TODO: Research the ability to use `infinite` instead of `greatestFiniteMagnitude` (in other places too).
        // This will require substantial amount of tests.
        _ = wait(timeout: TimeInterval.greatestFiniteMagnitude)
    }
}
