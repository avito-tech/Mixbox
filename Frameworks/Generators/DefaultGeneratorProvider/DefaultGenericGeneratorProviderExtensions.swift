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
                lengthGenerator: dependencyResolver.resolve()
            )
        }
    }
}

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

extension DependencyResolver {
    fileprivate func lengthGenerator() throws -> Generator<Int> {
        return RandomIntegerGenerator(
            randomNumberProvider: try resolve(),
            сlosedRange: 0...2
        )
    }
    
    fileprivate func defaultGeneratorResolvingStrategy() -> DefaultGeneratorResolvingStrategy {
        return (try? resolve() as DefaultGeneratorResolvingStrategy) ?? .empty
    }
}

#endif
