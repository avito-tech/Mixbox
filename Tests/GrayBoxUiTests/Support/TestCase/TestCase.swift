import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import MixboxGray
import MixboxBuiltinDi
import TestsIpc
@testable import TestedApp

class TestCase: BaseUiTestCase, ScreenOpener {
    var testType: TestType {
        .grayBox
    }
    
    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var permissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: Bundle.main.bundleIdentifier.unwrapOrFail(),
            displayName: ApplicationNameProvider.applicationName
        )
    }()
    
    override func dependencyInjectionConfiguration() -> DependencyInjectionConfiguration {
        DependencyInjectionConfiguration(
            dependencyCollectionRegisterer: GrayBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            ),
            performanceLogger: Singletons.performanceLogger
        )
    }
    
    override func setUp() {
        // TODO: Move to DI.
        
        let appDelegate = self.appDelegate
        
        lazilyInitializedIpcClient.ipcClient = appDelegate.startedInAppServices?.startedIpc.ipcClient.map { ipcClient in
            PerformanceLoggingIpcClient(
                ipcClient: ipcClient,
                performanceLogger: Singletons.performanceLogger
            )
        }
        
        let ipcRouterHolder: IpcRouterHolder = dependencies.resolve()
        ipcRouterHolder.ipcRouter = appDelegate.startedInAppServices?.startedIpc.ipcRouter
        
        synchronousIpcClient
            .callOrFail(method: SetTouchDrawerEnabledIpcMethod(), arguments: true)
            .getVoidReturnValueOrFail()
        
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
