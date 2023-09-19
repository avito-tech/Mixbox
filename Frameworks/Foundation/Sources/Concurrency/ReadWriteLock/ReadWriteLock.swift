#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Darwin

/// Example:
///
/// ```
/// let readWriteLock = ReadWriteLock()
///
/// readWriteLock.read { someSharedState.read() }
/// readWriteLock.write { someSharedState.write() }
/// ```
///
/// **Note: this implementation of read/write lock doesn't support upgrading/downgrading locks.**
/// (because Darwin's implementation of `pthread_rwlock` doesn't support it)
///
/// Example:
///
/// ```
/// let readWriteLock = ReadWriteLock()
/// readWriteLock.readLock() // ok
/// readWriteLock.writeLock() // deadlock instead of upgrade to write lock
/// ```
///
public final class ReadWriteLock {
    public var lock = pthread_rwlock_t()
    
    @inlinable
    public init() {
        pthread_rwlock_init(&lock, nil)
    }
    
    @inlinable
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    @inlinable
    public func readLock() {
        pthread_rwlock_rdlock(&lock)
    }
    
    @inlinable
    public func writeLock() {
        pthread_rwlock_wrlock(&lock)
    }
    
    @inlinable
    public func unlock() {
        pthread_rwlock_unlock(&lock)
    }
    
    @inlinable
    public func read<T>(
        body: () throws -> T
    ) rethrows -> T {
        readLock()
        defer {
            unlock()
        }
        return try body()
    }
    
    @inlinable
    @discardableResult
    public func write<T>(
        body: () throws -> T
    ) rethrows -> T {
        writeLock()
        defer {
            unlock()
        }
        return try body()
    }
}

#endif
