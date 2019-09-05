import Foundation
import MixboxFoundation

// TODO: It is possible to replace polling with waking up run loop on each change of `counter`. This
// will require modification of RunLoopSpinner.
public final class RunLoopSpinnerLockImpl: RunLoopSpinnerLock {
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    private let pollingInterval: TimeInterval
    
    // State
    private let timesEnteredSemaphore = DispatchSemaphore(value: 1)
    private var timesEntered: Int = 0
    
    public init(
        runLoopSpinnerFactory: RunLoopSpinnerFactory,
        pollingInterval: TimeInterval)
    {
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
        self.pollingInterval = pollingInterval
    }
    
    public func enter() {
        timesEnteredSemaphore.wait()
        defer {
            timesEnteredSemaphore.signal()
        }
        
        timesEntered += 1
    }
    
    public func leave() throws {
        timesEnteredSemaphore.wait()
        defer {
            timesEnteredSemaphore.signal()
        }
        
        timesEntered -= 1
        
        if timesEntered < 0 {
            throw ErrorString("leave() was called more times than enter()")
        }
    }
    
    public func wait(timeout: TimeInterval) -> RunLoopSpinnerLockWaitResult {
        let runLoopSpinner = runLoopSpinnerFactory.runLoopSpinner(
            timeout: timeout,
            maxSleepInterval: pollingInterval
        )
        
        let result = runLoopSpinner.spinUntil {
            !self.isLocked()
        }
        
        switch result {
        case .stopConditionMet:
            return .success
        case .timedOut:
            return .timedOut
        }
    }
    
    private func isLocked() -> Bool {
        timesEnteredSemaphore.wait()
        defer {
            timesEnteredSemaphore.signal()
        }
        
        return timesEntered != 0
    }
}
