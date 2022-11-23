#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

import MixboxDi

extension CaseIterable where Self: DefaultGeneratorProvider {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        return Generator<Self> {
            let allCases = self.allCases
            
            let indexGenerator = RandomIntegerGenerator(
                randomNumberProvider: try dependencyResolver.resolve(),
                range: 0..<allCases.count
            )

            let intIndex = try indexGenerator.generate()
            
            var index = allCases.startIndex
            allCases.formIndex(&index, offsetBy: intIndex)
            
            return allCases[index]
        }
    }
}

#endif
