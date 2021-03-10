#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension Dictionary: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        switch dependencyResolver.defaultGeneratorResolvingStrategy() {
        case .empty:
            return EmptyDictionaryGenerator()
        case .random:
            return try RandomDictionaryGenerator(
                anyGenerator: dependencyResolver.resolve(),
                lengthGenerator: dependencyResolver.lengthGenerator()
            )
        }
    }
}

#endif
