#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension DependencyResolver {
    func arrayLengthGenerator() throws -> Generator<Int> {
        return RandomIntegerGenerator(
            randomNumberProvider: try resolve(),
            сlosedRange: 0...2
        )
    }
    
    func dictionaryLengthGenerator() throws -> Generator<Int> {
        // Let it just be same as for arrays:
        return try arrayLengthGenerator()
    }
    
    func defaultGeneratorResolvingStrategy() -> DefaultGeneratorResolvingStrategy {
        return (try? resolve() as DefaultGeneratorResolvingStrategy) ?? .empty
    }
}

#endif
