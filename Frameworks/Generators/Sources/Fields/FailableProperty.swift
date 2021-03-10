#if MIXBOX_ENABLE_IN_APP_SERVICES

public struct FailableProperty<T> {
    private let getter: () throws -> T
    
    public init(getter: @escaping () throws -> T) {
        self.getter = getter
    }
    
    public func get() throws -> T {
        return try getter()
    }
}

#endif
