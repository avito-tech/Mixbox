#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI
#error("BuiltinDi is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_DI)
// The compilation is disabled
#else

import MixboxDi

final class RegisteredDependency {
    let scope: Scope
    let factory: (DependencyResolver) throws -> Any
    let instance: Any?
    
    init(
        scope: Scope,
        factory: @escaping (DependencyResolver) throws -> Any,
        instance: Any?)
    {
        self.scope = scope
        self.factory = factory
        self.instance = instance
    }
}

#endif
