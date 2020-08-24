import MixboxGenerators
import MixboxTestsFoundation

@dynamicMemberLookup
public final class TestFailingDynamicLookupFields<GeneratedType: RepresentableByFields> {
    private let dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>,
        testFailureRecorder: TestFailureRecorder)
    {
        self.dynamicLookupGenerator = dynamicLookupGenerator
        self.testFailureRecorder = testFailureRecorder
    }
    
    /// Example:
    ///
    /// ```
    /// $0.int = 42
    /// ```
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
}
