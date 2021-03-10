import MixboxGenerators
import MixboxTestsFoundation

public final class ConfiguredDynamicLookupGeneratorProviderImpl: ConfiguredDynamicLookupGeneratorProvider {
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let testFailureRecorder: TestFailureRecorder
    private let baseTestFailingGeneratorDependenciesFactory: BaseTestFailingGeneratorDependenciesFactory
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        testFailureRecorder: TestFailureRecorder,
        baseTestFailingGeneratorDependenciesFactory: BaseTestFailingGeneratorDependenciesFactory)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.testFailureRecorder = testFailureRecorder
        self.baseTestFailingGeneratorDependenciesFactory = baseTestFailingGeneratorDependenciesFactory
    }
    
    public func configuredDynamicLookupGenerator<T: RepresentableByFields, ModifiedConfigurator>(
        type: T.Type,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> ModifiedConfigurator,
        configure: @escaping (ModifiedConfigurator) throws -> ())
        throws
        -> DynamicLookupGenerator<T>
    {
        let dynamicLookupGenerator: DynamicLookupGenerator<T> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let testFailingDynamicLookupConfigurator = TestFailingDynamicLookupConfigurator<T>(
            testFailingDynamicLookupFields: TestFailingDynamicLookupFields<T>(
                dynamicLookupGenerator: dynamicLookupGenerator,
                testFailureRecorder: testFailureRecorder
            ),
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependenciesFactory.baseTestFailingGeneratorDependencies(
                configuredDynamicLookupGeneratorProvider: self
            )
        )
        
        try configure(
            modifyConfigurator(testFailingDynamicLookupConfigurator)
        )
        
        return dynamicLookupGenerator
    }
}
