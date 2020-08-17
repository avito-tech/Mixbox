import UiTestsSharedCode
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxBuiltinDi

class TestCase: BaseTestCase {
    override func makeDependencies() -> TestFailingDependencyResolver {
        TestCaseDi.make(
            dependencyCollectionRegisterer: BlackBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            ),
            dependencyInjectionFactory: BuiltinDependencyInjectionFactory()
        )
    }
    
    private var bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider {
        return BundleResourcePathProviderImpl(
            bundle: Bundle(for: TestCase.self)
        )
    }
    
    func launch(environment: [String: String] = [:]) {
        let commonEnvironment: [String: String] = [:] // insert your default envs here
        
        var mergedEnvironment = commonEnvironment
        
        for (key, value) in environment {
            mergedEnvironment[key] = value
        }
        
        let launchableApplicationProvider = dependencies.resolve() as LaunchableApplicationProvider
        let launchedApplication = launchableApplicationProvider
            .launchableApplication
            .launch(arguments: [], environment: mergedEnvironment)
        
        let lazilyInitializedIpcClient = dependencies.resolve() as LazilyInitializedIpcClient
        lazilyInitializedIpcClient.ipcClient = launchedApplication.ipcClient
    }
}
