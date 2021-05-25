#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension Array: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        switch dependencyResolver.defaultGeneratorResolvingStrategy() {
        case .empty:
            return EmptyArrayGenerator()
        case .random:
            return try RandomArrayGenerator(
                anyGenerator: dependencyResolver.resolve(),
                lengthGenerator: dependencyResolver.arrayLengthGenerator()
            )
        }
    }
}

#endif
