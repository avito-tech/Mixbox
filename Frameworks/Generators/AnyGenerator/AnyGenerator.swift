#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AnyGenerator {
    func generate<T>() throws -> T
}

#endif
