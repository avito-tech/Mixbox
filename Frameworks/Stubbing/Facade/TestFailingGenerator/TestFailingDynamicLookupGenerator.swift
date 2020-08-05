import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

// Same as `DynamicLookupGenerator`, but instead of throwing errors it fails tests
@dynamicMemberLookup
public class TestFailingDynamicLookupGenerator<GeneratedType>: Generator<GeneratedType> {
    private let dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>,
        testFailureRecorder: TestFailureRecorder)
    {
        self.dynamicLookupGenerator = dynamicLookupGenerator
        self.testFailureRecorder = testFailureRecorder
        
        super.init {
            try dynamicLookupGenerator.generate()
        }
    }
    
    public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> FieldType
    {
        get {
            do {
                return try dynamicLookupGenerator[dynamicMember: keyPath].get()
            } catch {
                testFailureRecorder.recordUnavoidableFailure(
                    description:
                    """
                    Failed to get \(FieldType.self) from \(GeneratedType.self) by keypath \(keyPath): \(error)
                    """
                )
            }
        }
        set {
            dynamicLookupGenerator[dynamicMember: keyPath].set(newValue)
        }
    }
    
    public subscript<FieldType: GeneratableByFields>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> TestFailingNestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>
    {
        get {
            return TestFailingNestedDynamicLookupGeneratorStubber(
                nestedDynamicLookupGeneratorStubber: dynamicLookupGenerator[dynamicMember: keyPath],
                testFailureRecorder: testFailureRecorder
            )
        }
    }
}
