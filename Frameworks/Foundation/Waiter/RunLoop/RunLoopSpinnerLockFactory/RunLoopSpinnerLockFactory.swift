#if MIXBOX_ENABLE_IN_APP_SERVICES
import Foundation

public protocol RunLoopSpinnerLockFactory: class {
    func runLoopSpinnerLock(pollingInterval: TimeInterval) -> RunLoopSpinnerLock
}

#endif
