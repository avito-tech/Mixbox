#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI
#error("BuiltinDi is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI)
// The compilation is disabled
#else

import MixboxDi

public final class BuiltinDependencyInjectionFactory: DependencyInjectionFactory {
    public init() {
    }
    
    public func dependencyInjection() -> DependencyInjection {
        return BuiltinDependencyInjection()
    }
}

#endif
