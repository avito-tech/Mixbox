import MixboxDi
import MixboxTestsFoundation

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
            return dynamicLookupGenerator[dynamicMember: keyPath]
        }
        set {
            dynamicLookupGenerator[dynamicMember: keyPath] = newValue
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
