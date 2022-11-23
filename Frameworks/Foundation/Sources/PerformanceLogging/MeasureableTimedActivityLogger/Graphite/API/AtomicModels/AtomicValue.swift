#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Dispatch
import Foundation

public class AtomicValue<T> {
    internal var value: T
    private let lock = NSLock()

    public init(_ value: T) {
        self.value = value
    }
    
    @discardableResult
    public func withExclusiveAccess<R>(work: (inout T) throws -> (R)) rethrows -> R {
        lock.lock()
        defer { lock.unlock() }
        let result = try work(&value)
        didUpdateValue()
        return result
    }
    
    public func currentValue() -> T {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    public func set(_ newValue: T) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
        didUpdateValue()
    }
    
    internal func didUpdateValue() {}
}

#endif
