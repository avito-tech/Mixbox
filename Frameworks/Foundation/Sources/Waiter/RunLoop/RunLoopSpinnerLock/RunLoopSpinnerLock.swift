#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Mimics DispatchGroup interface, but doesn't lock current thread.
// Instead it spins runloop. This may prevent deadlocks if completion of some action is scheduled on current thread
// and requires spinning runloop to be called.
//
// This class is thread safe.
//

import Foundation

public protocol RunLoopSpinnerLock: AnyObject {
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

#endif
