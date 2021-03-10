#if MIXBOX_ENABLE_IN_APP_SERVICES

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
