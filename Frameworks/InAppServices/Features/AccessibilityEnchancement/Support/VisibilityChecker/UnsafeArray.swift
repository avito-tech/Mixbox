#if MIXBOX_ENABLE_IN_APP_SERVICES

public class UnsafeArray<T> {
    public let pointer: UnsafeMutablePointer<T>
    public let count: Int
    
    public init(count: Int) {
        self.count = count
        self.pointer = UnsafeMutablePointer<T>.allocate(capacity: count)
    }
    
    deinit {
        pointer.deallocate()
    }
    
    public subscript(index: Int) -> T {
        get {
            return pointer[index]
        }
        _modify {
            yield &pointer[index]
        }
    }
    
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
    
    public func copy() -> UnsafeArray<T> {
        let copy = UnsafeArray<T>(count: count)
        memcpy(copy.pointer, pointer, count)
        return copy
    }
}

#endif
