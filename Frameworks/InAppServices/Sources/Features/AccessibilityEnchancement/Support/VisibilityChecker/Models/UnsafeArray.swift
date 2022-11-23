#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class UnsafeArray<T> {
    public let pointer: UnsafeMutablePointer<T>
    public let count: Int
    
    public init(count: Int) {
        self.count = count
        self.pointer = UnsafeMutablePointer<T>.allocate(capacity: count)
    }
    
    deinit {
        pointer.deallocate()
    }
    
    @inline(__always)
    public final subscript(index: Int) -> T {
        get {
            return pointer[index]
        }
        _modify {
            yield &pointer[index]
        }
    }
    
    public func copy() -> UnsafeArray<T> {
        let copy = UnsafeArray<T>(count: count)
        memcpy(copy.pointer, pointer, count)
        return copy
    }
}

extension UnsafeArray {
    public func toArray() -> [T] {
        return [T](
            unsafeUninitializedCapacity: count,
            initializingWith: { (outPointer, outCount) in
                if let address = outPointer.baseAddress {
                    memcpy(address, pointer, count)
                    outCount = count
                } else {
                    outCount = 0
                }
            }
        )
    }
    
    public static func fromArray(_ array: [T]) -> UnsafeArray<T> {
        let unsafeArray = UnsafeArray(count: array.count)
        
        array.enumerated().forEach { index, value in
            unsafeArray[index] = value
        }
        
        return unsafeArray
    }
}

#endif
