#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol DependencyInjectionFactory {
    func dependencyInjection() -> DependencyInjection
}

#endif
