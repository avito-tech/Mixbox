#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

public final class ConditionLock {
    private let conditionLock: NSConditionLock
    
    public init(condition: Int) {
        conditionLock = NSConditionLock(condition: condition)
    }
    
    /// Sets the current condition or returns it.
    public var condition: Int {
        get {
            conditionLock.condition
        }
        set {
            conditionLock.lock()
            conditionLock.unlock(withCondition: newValue)
        }
    }
    
    public func lock() {
        conditionLock.lock()
    }
    
    public func unlock() {
        conditionLock.unlock()
    }
    
    public func lock(whenCondition: Int, before: Date = .distantFuture) -> Bool{
        return conditionLock.lock(whenCondition: condition, before: before)
    }
    
    public func unlock(andSetCondition condition: Int) {
        conditionLock.unlock(withCondition: condition)
    }
    
    /// The receiver’s condition must be equal to condition before the locking operation will succeed.
    /// This method blocks the thread’s execution until the lock can be acquired or limit is reached.
    /// - Parameter condition: The condition to match on.
    /// - Parameter before: The date by which the lock must be acquired or the attempt will time out.
    /// - Returns: `true` if the lock is acquired within the time limit, `false` otherwise.
    @discardableResult
    public func lockAndUnlock(
        whenCondition condition: Int,
        before: Date = .distantFuture,
        work: (Bool) -> () = { _ in })
        -> Bool
    {
        let result = conditionLock.lock(whenCondition: condition, before: before)
        defer { conditionLock.unlock() }
        work(result)
        return result
    }
    
    @discardableResult
    public func whileLocked(before: Date = .distantFuture, work: () -> ()) -> Bool {
        let result = conditionLock.lock(before: before)
        defer { conditionLock.unlock() }
        work()
        return result
    }
}

#endif
