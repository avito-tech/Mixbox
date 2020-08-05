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
        configure: @escaping (DynamicLookupGenerator<FieldType>) throws -> ())
    {
        do {
            try nestedDynamicLookupGeneratorStubber.stub(configure: configure)
        } catch {
            testFailureRecorder.recordFailure(
                description: String(describing: error),
                shouldContinueTest: false
            )
        }
    }
}
