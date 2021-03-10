import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

// Note: Avoid adding functions here. Every function can collide with dynamic member.
//       However, I think if we use function with same name everywhere it will negatively
//       impact performance or make compilation errors harder to debug.
@dynamicMemberLookup
public class TestFailingDynamicLookupConfigurator<GeneratedType: RepresentableByFields>:
    BaseTestFailingGenerator
{
    /// Used to resolve naming collisions.
    ///
    /// Example:
    ///
    /// ```
    /// // Not working:
    /// // $0.dictionary = $0.dictionary(count: 1)
    ///
    /// // Working:
    /// // $0.fields.dictionary = $0.dictionary(count: 1)
    /// ```
    public let fields: TestFailingDynamicLookupFields<GeneratedType>
    
    // For `with(index:)` function.
    private let baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies
    
    public init(
        testFailingDynamicLookupFields: TestFailingDynamicLookupFields<GeneratedType>,
        baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies)
    {
        self.fields = testFailingDynamicLookupFields
        self.baseTestFailingGeneratorDependencies = baseTestFailingGeneratorDependencies
        
        super.init(
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependencies
        )
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
            fields[dynamicMember: keyPath]
        }
        set {
            fields[dynamicMember: keyPath] = newValue
        }
    }
}

// Internal
extension TestFailingDynamicLookupConfigurator {
    func with(index: Int) -> TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType> {
        return TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType>(
            testFailingDynamicLookupFields: fields,
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependencies,
            index: index
        )
    }
}
