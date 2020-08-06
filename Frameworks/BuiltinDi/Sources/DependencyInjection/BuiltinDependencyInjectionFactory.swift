#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

public final class BuiltinDependencyInjectionFactory: DependencyInjectionFactory {
    public init() {
    }
    
    public func dependencyInjection() -> DependencyInjection {
        return BuiltinDependencyInjection()
    }
}

#endif
