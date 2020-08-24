import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public class TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType: RepresentableByFields>:
    TestFailingDynamicLookupConfigurator<GeneratedType>
{
    private let storedIndex: Int
    
    public init(
        testFailingDynamicLookupFields: TestFailingDynamicLookupFields<GeneratedType>,
        baseTestFailingGeneratorDependencies: BaseTestFailingGeneratorDependencies,
        index: Int)
    {
        self.storedIndex = index
        
        super.init(
            testFailingDynamicLookupFields: testFailingDynamicLookupFields,
            baseTestFailingGeneratorDependencies: baseTestFailingGeneratorDependencies
        )
    }
    
    public func index() -> Int {
        storedIndex
    }
}
