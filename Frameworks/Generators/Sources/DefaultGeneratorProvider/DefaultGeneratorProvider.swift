#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

import MixboxDi

// DefaultGeneratorProvider is used to resolve generators for generic types such as Dictionary<T, U>,
// because generic types can not be registered in DI in Swift due to language limitations:
// generic specializations for all classes are required to exist at compile time.
//
public protocol DefaultGeneratorProvider: TypeErasedDefaultGeneratorProvider {
    static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self>
}

extension DefaultGeneratorProvider {
    public static func typeErasedDefaultGenerator(dependencyResolver: DependencyResolver) throws -> Any {
        return try defaultGenerator(dependencyResolver: dependencyResolver)
    }
}

#endif
