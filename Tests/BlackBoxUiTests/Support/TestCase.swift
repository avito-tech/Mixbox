import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import SBTUITestTunnel
import MixboxIpcSbtuiClient
import MixboxBuiltinIpc
import MixboxIpc
import MixboxFoundation

class TestCase: BaseUiTestCase, ScreenOpener {
    // Prototype of fast launching, see usage:
    // UPD: Implemented in Avito. TODO: Sync with Mixbox.
    static var everLaunched = false
    
    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var testRunnerPermissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            // swiftlint:disable:next force_unwrapping
            bundleId: Bundle.main.bundleIdentifier!,
            displayName: "We don't care at the moment",
            testFailureRecorder: dependencies.resolve()
        )
    }()

    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var permissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: XCUIApplication().bundleID,
            displayName: ApplicationNameProvider.applicationName,
            testFailureRecorder: dependencies.resolve()
        )
    }()

    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    var launchableApplicationProvider: LaunchableApplicationProvider {
        return dependencies.resolve()
    }
    
    override func makeDependencies() -> TestCaseDependenciesResolver {
        TestCaseDependenciesResolver(
            registerer: BlackBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            )
        )
    }
    
    // Just to store server (to not let him die during test).
    // TODO: Replace with `IpcRouterHolder`
    private var ipcRouter: IpcRouter?
    
    func launch(environment: [String: String], useBuiltinIpc: Bool = false) {
        let commonEnvironment = [
            // Fixes assertion failure when view is loaded multiple times and uses ViewIpc
            "MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY": "true",
            // TODO: What is it for? Is it just a default screen?
            "MB_TESTS_screenName": "DummyForLaunchingUiTestsView"
        ]
        
        var mergedEnvironment = commonEnvironment
        
        for (key, value) in environment {
            mergedEnvironment[key] = value
        }
        
        launchableApplicationProvider.shouldCreateLaunchableApplicationWithBuiltinIpc = useBuiltinIpc
        
        let launchedApplication = launchableApplicationProvider
            .launchableApplication
            .launch(arguments: [], environment: mergedEnvironment)
        
        lazilyInitializedIpcClient.ipcClient = launchedApplication.ipcClient
        ipcRouter = launchedApplication.ipcRouter
    }
    
    // For tests of IPC
    func ensureIpcIsInitiated() {
        launch(environment: [:], useBuiltinIpc: true)
    }
    
    func openScreen(
        name: String,
        additionalEnvironment: [String: String])
    {
        openScreen(
            name: name,
            useBuiltinIpc: false,
            additionalEnvironment: additionalEnvironment
        )
    }
    
    func openScreen(
        name: String,
        useBuiltinIpc: Bool,
        additionalEnvironment: [String: String] = [:])
    {
        var additionalEnvironment = additionalEnvironment
        additionalEnvironment["MB_TESTS_screenName"] = name
        
        launch(
            environment: additionalEnvironment,
            useBuiltinIpc: useBuiltinIpc
        )
    }
}
