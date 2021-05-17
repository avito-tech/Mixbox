#if MIXBOX_ENABLE_IN_APP_SERVICES

import Foundation

extension NSLocking {
    public func lockWhile<T>(body: () throws -> T) rethrows -> T {
        lock()
        
        defer {
            unlock()
        }
        
        return try body()
    }
}

#endif
