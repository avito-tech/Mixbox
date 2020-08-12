import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

@dynamicMemberLookup
public class TestFailingDynamicLookupGeneratorConfigurator<GeneratedType: RepresentableByFields> {
    private let dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let testFailureRecorder: TestFailureRecorder
    private let testFailingGenerator: TestFailingGenerator
    
    public init(
        dynamicLookupGenerator: DynamicLookupGenerator<GeneratedType>,
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        testFailureRecorder: TestFailureRecorder,
        testFailingGenerator: TestFailingGenerator)
    {
        self.dynamicLookupGenerator = dynamicLookupGenerator
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.testFailureRecorder = testFailureRecorder
        self.testFailingGenerator = testFailingGenerator
    }
    
    // For stubbing fields
    //
    // Example:
    //
    // ```
    // $0.value = 42
    // ```
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
    
    // For stubbing fields of a nested struct/class
    //
    // Example:
    //
    // ```
    // $0.myModel.stub {
    //     $0.value = 42
    // }
    // ```
    public subscript<FieldType: GeneratableByFields>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> TestFailingNestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>
    {
        get {
            return TestFailingNestedDynamicLookupGeneratorStubber(
                nestedDynamicLookupGeneratorStubber: dynamicLookupGenerator[dynamicMember: keyPath],
                dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
                byFieldsGeneratorResolver: byFieldsGeneratorResolver,
                testFailureRecorder: testFailureRecorder,
                testFailingGenerator: testFailingGenerator
            )
        }
    }
    
    // For stubbing deeply nested things with fields.
    //
    // Note: may be removed in the future, because we want to make stubbing more
    // declarative rather than imperative.
    //
    // Example:
    //
    // ```
    // $0.arrayOfMyModel = [
    //     $0.generate { $0.value = 42 },
    //     $0.generate { $0.value = 43 }
    // ]
    // ```
    public func generate<T: RepresentableByFields>(
        type: T.Type = T.self,
        configure: @escaping (TestFailingDynamicLookupGeneratorConfigurator<T>) throws -> ())
        -> T
    {
        do {
            let dynamicLookupGenerator: DynamicLookupGenerator<T> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
            
            let testFailingDynamicLookupGeneratorConfigurator = TestFailingDynamicLookupGeneratorConfigurator<T>(
                dynamicLookupGenerator: dynamicLookupGenerator,
                dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
                byFieldsGeneratorResolver: byFieldsGeneratorResolver,
                testFailureRecorder: testFailureRecorder,
                testFailingGenerator: testFailingGenerator
            )
            
            let testFailingDynamicLookupGeneratorProvider = TestFailingDynamicLookupGeneratorProvider<T>(
                dynamicLookupGenerator: dynamicLookupGenerator,
                testFailingDynamicLookupGeneratorConfigurator: testFailingDynamicLookupGeneratorConfigurator
            )
            
            try configure(testFailingDynamicLookupGeneratorConfigurator)
            
            return try testFailingDynamicLookupGeneratorProvider.generator().generate()
        } catch {
            testFailureRecorder.recordUnavoidableFailure(
                description:
                """
                Failed to generate \(T.self): \(error)
                """
            )
        }
    }
    
    // For stubbing deeply nested things without fields.
    //
    // Note: may be removed in the future, because we want to make stubbing more
    // declarative rather than imperative.
    //
    // Example:
    //
    // ```
    // $0.arrayOfMyModel = [
    //     $0.generate { $0.value = 42 },
    //     $0.generate { $0.value = 43 }
    // ]
    // ```
    public func generate<T>(
        type: T.Type = T.self)
        -> T
    {
        testFailingGenerator.generate()
    }
}
