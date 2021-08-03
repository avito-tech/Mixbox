#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension Set: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        switch dependencyResolver.defaultGeneratorResolvingStrategy() {
        case .empty:
            return EmptySetGenerator()
        case .random:
            return try RandomSetGenerator(
                anyGenerator: dependencyResolver.resolve(),
                lengthGenerator: dependencyResolver.arrayLengthGenerator()
            )
        }
    }
}

#endif
