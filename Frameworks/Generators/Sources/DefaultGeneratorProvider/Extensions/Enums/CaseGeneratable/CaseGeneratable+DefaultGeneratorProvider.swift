#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxDi

extension CaseGeneratable where Self: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        let unboundedCaseIndexGenerator = RandomIntegerGenerator(
            randomNumberProvider: try dependencyResolver.resolve(),
            range: 0..<Int.max
        )
        let anyGenerator: AnyGenerator = try dependencyResolver.resolve()
        
        return Generator<Self> {
            let allCasesGenerators = Self.allCasesGenerators
            
            if allCasesGenerators.isEmpty {
                throw GeneratorError(
                    """
                    Can not generate object of type \(type(of: self)) from conformance to `CaseGeneratable`: \
                    `allCasesGenerators` returned empty array. You should either return something, or \
                    remove conformance to `CaseGeneratable` or to `DefaultGeneratorProvider`, or \
                    implement `DefaultGeneratorProvider` in your type.
                    """
                )
            } else {
                let caseIndex = try unboundedCaseIndexGenerator.generate() % allCasesGenerators.count
                
                let generator = allCasesGenerators[caseIndex]
                
                return try generator(anyGenerator)
            }
        }
    }
}

#endif
