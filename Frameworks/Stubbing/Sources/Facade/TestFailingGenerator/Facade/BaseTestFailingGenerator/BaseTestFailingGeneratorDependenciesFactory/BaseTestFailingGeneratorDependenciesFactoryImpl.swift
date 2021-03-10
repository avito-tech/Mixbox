import MixboxGenerators
import MixboxTestsFoundation

public final class BaseTestFailingGeneratorDependenciesFactoryImpl: BaseTestFailingGeneratorDependenciesFactory {
    private let anyGenerator: AnyGenerator
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        anyGenerator: AnyGenerator,
        testFailureRecorder: TestFailureRecorder)
    {
        self.anyGenerator = anyGenerator
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func baseTestFailingGeneratorDependencies(
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider,
        testFailingGeneratorObserver: TestFailingGeneratorObserver)
        -> BaseTestFailingGeneratorDependencies
    {
        let testFailingObjectGeneratorWithConfiguratorModification = TestFailingObjectGeneratorWithConfiguratorModificationImpl(
            configuredDynamicLookupGeneratorProvider: configuredDynamicLookupGeneratorProvider,
            testFailureRecorder: testFailureRecorder
        )
        
        let testFailingAnyGenerator = TestFailingAnyGeneratorImpl(
            anyGenerator: anyGenerator
        )
        
        let testFailingObjectGenerator = TestFailingObjectGeneratorImpl(
            generator: testFailingObjectGeneratorWithConfiguratorModification
        )
        
        let testFailingArrayGenerator = TestFailingArrayGeneratorImpl(
            testFailingObjectGeneratorWithConfiguratorModification: testFailingObjectGeneratorWithConfiguratorModification,
            testFailingAnyGenerator: testFailingAnyGenerator
        )
        
        let testFailingDictionaryGenerator = TestFailingDictionaryGeneratorImpl(
            testFailingObjectGeneratorWithConfiguratorModification: testFailingObjectGeneratorWithConfiguratorModification,
            testFailingAnyGenerator: testFailingAnyGenerator,
            testFailureRecorder: testFailureRecorder
        )
        
        let testFailingOptionalGenerator = TestFailingOptionalGeneratorImpl(
            testFailingAnyGenerator: testFailingAnyGenerator,
            testFailingObjectGenerator: testFailingObjectGenerator
        )
        
        return BaseTestFailingGeneratorDependencies(
            testFailingAnyGenerator: testFailingAnyGenerator,
            testFailingObjectGenerator: testFailingObjectGenerator,
            testFailingArrayGenerator: testFailingArrayGenerator,
            testFailingDictionaryGenerator: testFailingDictionaryGenerator,
            testFailingOptionalGenerator: testFailingOptionalGenerator,
            testFailingGeneratorObserver: testFailingGeneratorObserver
        )
    }
}
