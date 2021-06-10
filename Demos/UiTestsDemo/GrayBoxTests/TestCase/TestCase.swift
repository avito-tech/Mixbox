import UiTestsSharedCode
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxIpc
import MixboxBuiltinDi
@testable import App

class TestCase: BaseTestCase {
    override func makeDependencies() -> TestFailingDependencyResolver {
        TestCaseDi.make(
            dependencyCollectionRegisterer: GrayBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            ),
            dependencyInjectionFactory: BuiltinDependencyInjectionFactory()
        )
    }
    
    override func setUp() {
        super.setUp()
        
        let appDelegate = self.appDelegate
        let lazilyInitializedIpcClient = dependencies.resolve() as LazilyInitializedIpcClient
        
        guard let startedInAppServices = appDelegate.startedInAppServices else {
            XCTFail("InAppServices were not started")
            return
        }
        
        lazilyInitializedIpcClient.ipcClient = startedInAppServices.startedIpc.ipcClient
    }
    
    // MARK: - Private
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UnavoidableFailure.fail("UIApplication.shared.delegate is not AppDelegate")
        }
        
        return appDelegate
    }
    
    private var bundleResourcePathProviderForTestsTarget: BundleResourcePathProvider {
        return BundleResourcePathProviderImpl(
            bundle: Bundle(for: TestCase.self)
        )
    }
}
