import MixboxGenerators

public final class TestFailingDynamicLookupGeneratorProvider<GeneratedType: RepresentableByFields>  {
    private let dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>
    private let testFailingDynamicLookupGeneratorConfigurator: TestFailingDynamicLookupGeneratorConfigurator<GeneratedType>
    
    public init(
        dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>,
        testFailingDynamicLookupGeneratorConfigurator: TestFailingDynamicLookupGeneratorConfigurator<GeneratedType>)
    {
        self.dynamicLookupGenerator = dynamicLookupGenerator
        self.testFailingDynamicLookupGeneratorConfigurator = testFailingDynamicLookupGeneratorConfigurator
    }
    
    public func generator() -> Generator<GeneratedType> {
        return Generator<GeneratedType> { [dynamicLookupGenerator] in
            try dynamicLookupGenerator.generate()
        }
    }
}
