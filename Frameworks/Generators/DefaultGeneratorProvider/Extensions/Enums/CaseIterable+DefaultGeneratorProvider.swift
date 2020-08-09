#if MIXBOX_ENABLE_IN_APP_SERVICES

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
