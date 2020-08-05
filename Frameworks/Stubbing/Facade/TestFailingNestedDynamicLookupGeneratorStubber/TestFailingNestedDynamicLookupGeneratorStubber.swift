import MixboxTestsFoundation
import MixboxGenerators

public final class TestFailingNestedDynamicLookupGeneratorStubber<GeneratedType, FieldType: GeneratableByFields> {
    private let nestedDynamicLookupGeneratorStubber: NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        nestedDynamicLookupGeneratorStubber: NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>,
        testFailureRecorder: TestFailureRecorder)
    {
        self.nestedDynamicLookupGeneratorStubber = nestedDynamicLookupGeneratorStubber
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func stub(
        configure: @escaping (TestFailingDynamicLookupGenerator<FieldType>) throws -> ())
    {
        do {
            try nestedDynamicLookupGeneratorStubber.stub { [testFailureRecorder] dynamicLookupGenerator in
                let testFailingDynamicLookupGenerator = TestFailingDynamicLookupGenerator(
                    dynamicLookupGenerator: dynamicLookupGenerator,
                    testFailureRecorder: testFailureRecorder
                )
                
                try configure(testFailingDynamicLookupGenerator)
            }
        } catch {
            testFailureRecorder.recordFailure(
                description: String(describing: error),
                shouldContinueTest: false
            )
        }
    }
}
