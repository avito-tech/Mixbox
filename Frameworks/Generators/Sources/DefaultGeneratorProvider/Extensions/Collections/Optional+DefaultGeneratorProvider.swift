#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension Optional: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        switch dependencyResolver.defaultGeneratorResolvingStrategy() {
        case .empty:
            return EmptyOptionalGenerator()
        case .random:
            return try RandomOptionalGenerator(
                anyGenerator: dependencyResolver.resolve(),
                isNoneGenerator: ConstantGenerator(false)
            )
        }
    }
}

#endif
