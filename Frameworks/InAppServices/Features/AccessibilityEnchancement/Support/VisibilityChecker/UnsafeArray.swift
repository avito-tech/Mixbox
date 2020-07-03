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
}

#endif
