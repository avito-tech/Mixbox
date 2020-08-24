import MixboxDi
import MixboxTestsFoundation
import MixboxGenerators

public class TestFailingDynamicLookupConfiguratorWithIndex<GeneratedType: RepresentableByFields>:
    TestFailingDynamicLookupConfigurator<GeneratedType>
{
    private let storedIndex: Int
    
    public init(
        testFailingDynamicLookupFields: TestFailingDynamicLookupFields<GeneratedType>,
        testFailingDynamicLookupGenerator: TestFailingDynamicLookupGenerator<GeneratedType>,
        index: Int)
    {
        self.storedIndex = index
        
        super.init(
            testFailingDynamicLookupFields: testFailingDynamicLookupFields,
            testFailingDynamicLookupGenerator: testFailingDynamicLookupGenerator
        )
    }
    
    public func index() -> Int {
        storedIndex
    }
}
