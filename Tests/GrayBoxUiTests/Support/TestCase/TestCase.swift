import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxGray
import TestsIpc
@testable import TestedApp

class TestCase: BaseUiTestCase, ScreenOpener {
    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var permissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: Bundle.main.bundleIdentifier.unwrapOrFail(),
            displayName: ApplicationNameProvider.applicationName,
            testFailureRecorder: dependencies.resolve()
        )
    }()
    
    override func makeDependencies() -> TestCaseDependenciesResolver {
        TestCaseDependenciesResolver(
            registerer: GrayBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            )
        )
    }
    
    override func setUp() {
        // TODO: Move to DI (when Dip will be used for DI).
        
        let appDelegate = self.appDelegate
        
        lazilyInitializedIpcClient.ipcClient = appDelegate.ipcClient
        
        let ipcRouterHolder: IpcRouterHolder = dependencies.resolve()
        ipcRouterHolder.ipcRouter = appDelegate.ipcRouter
        
        super.setUp()
    }
    
    override func tearDown() {
        if !reuseState {
            _ = synchronousIpcClient.callOrFail(
                method: SetScreenIpcMethod(),
                arguments: nil
            )
        }
        
        legacyNetworking.stubbing.removeAllStubs()
        
        super.tearDown()
    }
    
    func ensureIpcIsInitiated() {
        // IPC is always initiated in GrayBox tests (see setUp)
    }
    
    func openScreen(
        name: String,
        additionalEnvironment: [String: String])
    {
        _ = synchronousIpcClient.callOrFail(
            method: SetScreenIpcMethod(),
            arguments: SetScreenIpcMethod.Screen(
                viewType: name
            )
        )
    }
    
    // MARK: - Private
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UnavoidableFailure.fail("UIApplication.shared.delegate is not AppDelegate")
        }
        
        return appDelegate
    }
}
