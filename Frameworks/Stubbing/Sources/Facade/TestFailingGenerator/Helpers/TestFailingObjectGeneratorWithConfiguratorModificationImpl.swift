import MixboxGenerators
import MixboxTestsFoundation

public final class TestFailingObjectGeneratorWithConfiguratorModificationImpl: TestFailingObjectGeneratorWithConfiguratorModification {
    private let configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        configuredDynamicLookupGeneratorProvider: ConfiguredDynamicLookupGeneratorProvider,
        testFailureRecorder: TestFailureRecorder)
    {
        self.configuredDynamicLookupGeneratorProvider = configuredDynamicLookupGeneratorProvider
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func generate<T: RepresentableByFields, MC>(
        type: T.Type = T.self,
        modifyConfigurator: (TestFailingDynamicLookupConfigurator<T>) throws -> MC,
        configure: @escaping (MC) throws -> ())
        -> T
    {
        do {
            let dynamicLookupGenerator = try configuredDynamicLookupGeneratorProvider.configuredDynamicLookupGenerator(
                type: T.self,
                modifyConfigurator: modifyConfigurator,
                configure: configure
            )
            
            return try dynamicLookupGenerator.generate()
        } catch {
            testFailureRecorder.recordUnavoidableFailure(
                description:
                """
                Failed to generate \(T.self): \(error)
                """
            )
        }
    }
}
