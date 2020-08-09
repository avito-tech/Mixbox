#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension DependencyResolver {
    func lengthGenerator() throws -> Generator<Int> {
        return RandomIntegerGenerator(
            randomNumberProvider: try resolve(),
            сlosedRange: 0...2
        )
    }
    
    func defaultGeneratorResolvingStrategy() -> DefaultGeneratorResolvingStrategy {
        return (try? resolve() as DefaultGeneratorResolvingStrategy) ?? .empty
    }
}

#endif
