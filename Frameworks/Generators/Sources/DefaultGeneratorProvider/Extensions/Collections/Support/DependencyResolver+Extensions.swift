#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

import MixboxDi

extension DependencyResolver {
    func arrayLengthGenerator() throws -> Generator<Int> {
        return RandomIntegerGenerator(
            randomNumberProvider: try resolve(),
            closedRange: 0...2
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
