#if MIXBOX_ENABLE_FRAMEWORK_DI && MIXBOX_DISABLE_FRAMEWORK_DI
#error("Di is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_DI)
// The compilation is disabled
#else

public protocol DependencyResolver: AnyObject {
    // Use this function in custom implementations/wrappers of `DependencyResolver`.
    // See `CompoundDependencyResolver`. Use `resolve<T>()` for everything else, for
    // example, for resolving your dependencies.
    func resolve<T>(nestedDependencyResolver: DependencyResolver) throws -> T
}

extension DependencyResolver {
    // Use this function for most cases.
    public func resolve<T>() throws -> T {
        return try resolve(nestedDependencyResolver: self)
    }
}

#endif
