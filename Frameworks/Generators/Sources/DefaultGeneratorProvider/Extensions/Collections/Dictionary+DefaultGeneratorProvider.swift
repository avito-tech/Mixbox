#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

import MixboxDi

extension Dictionary: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        switch dependencyResolver.defaultGeneratorResolvingStrategy() {
        case .empty:
            return EmptyDictionaryGenerator()
        case .random:
            return try RandomDictionaryGenerator(
                anyGenerator: dependencyResolver.resolve(),
                lengthGenerator: dependencyResolver.dictionaryLengthGenerator()
            )
        }
    }
}

#endif
