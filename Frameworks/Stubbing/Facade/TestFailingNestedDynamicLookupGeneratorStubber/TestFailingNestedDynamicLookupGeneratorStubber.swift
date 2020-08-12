import MixboxTestsFoundation
import MixboxGenerators

public final class TestFailingNestedDynamicLookupGeneratorStubber<GeneratedType: RepresentableByFields, FieldType: GeneratableByFields> {
    private let nestedDynamicLookupGeneratorStubber: NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let testFailureRecorder: TestFailureRecorder
    private let testFailingGenerator: TestFailingGenerator
    
    public init(
        nestedDynamicLookupGeneratorStubber: NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>,
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        testFailureRecorder: TestFailureRecorder,
        testFailingGenerator: TestFailingGenerator)
    {
        self.nestedDynamicLookupGeneratorStubber = nestedDynamicLookupGeneratorStubber
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.testFailureRecorder = testFailureRecorder
        self.testFailingGenerator = testFailingGenerator
    }
    
    public func stub(
        configure: @escaping (TestFailingDynamicLookupGeneratorConfigurator<FieldType>) throws -> ())
    {
        do {
            try nestedDynamicLookupGeneratorStubber.stub { [testFailureRecorder, dynamicLookupGeneratorFactory, byFieldsGeneratorResolver, testFailingGenerator] dynamicLookupGenerator in
                let testFailingDynamicLookupGeneratorConfigurator = TestFailingDynamicLookupGeneratorConfigurator<FieldType>(
                    dynamicLookupGenerator: dynamicLookupGenerator,
                    dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
                    byFieldsGeneratorResolver: byFieldsGeneratorResolver,
                    testFailureRecorder: testFailureRecorder,
                    testFailingGenerator: testFailingGenerator
                )
                
                try configure(testFailingDynamicLookupGeneratorConfigurator)
            }
        } catch {
            testFailureRecorder.recordFailure(
                description: String(describing: error),
                shouldContinueTest: false
            )
        }
    }
}
