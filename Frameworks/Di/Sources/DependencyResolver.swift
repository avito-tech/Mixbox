#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DependencyResolver: class {
    func resolve<T>() throws -> T
}

#endif
