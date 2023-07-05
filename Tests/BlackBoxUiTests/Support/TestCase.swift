import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxBlack
import MixboxSBTUITestTunnelClient
import MixboxIpcSbtuiClient
import MixboxBuiltinIpc
import MixboxBuiltinDi
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation
import TestsIpc

class TestCase: BaseUiTestCase, ScreenOpener {
    var testType: TestType {
        .blackBox
    }
    
    // Prototype of fast launching, see usage:
    // UPD: Implemented in Avito. TODO: Sync with Mixbox.
    static var everLaunched = false
    
    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var testRunnerPermissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            // swiftlint:disable:next force_unwrapping
            bundleId: Bundle.main.bundleIdentifier!,
            displayName: "We don't care at the moment"
        )
    }()

    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    lazy var permissions: ApplicationPermissionsSetter = {
        applicationPermissionsSetterFactory.applicationPermissionsSetter(
            bundleId: XCUIApplication().bundleID,
            displayName: ApplicationNameProvider.applicationName
        )
    }()

    // TODO: Fix according to comment in `BaseUiTestCase+ResolveFunctions`
    var launchableApplicationProvider: LaunchableApplicationProvider {
        return dependencies.resolve()
    }
    
    override func dependencyInjectionConfiguration() -> DependencyInjectionConfiguration {
        DependencyInjectionConfiguration(
            dependencyCollectionRegisterer: BlackBoxTestCaseDependencies(
                bundleResourcePathProviderForTestsTarget: bundleResourcePathProviderForTestsTarget
            ),
            performanceLogger: Singletons.performanceLogger
        )
    }
    
    // Just to store server (to not let him die during test).
    // TODO: Replace with `IpcRouterHolder`
    private var ipcRouter: IpcRouter?
    
    func launch(environment: [String: String], useBuiltinIpc: Bool = false) {
        let commonEnvironment = [
            // Fixes assertion failure when view is loaded multiple times and uses ViewIpc
            "MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY": "true"
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
        
        synchronousIpcClient
            .callOrFail(method: SetTouchDrawerEnabledIpcMethod(), arguments: true)
            .getVoidReturnValueOrFail()
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
        launch(
            environment: additionalEnvironment,
            useBuiltinIpc: useBuiltinIpc
        )
        
        // TODO: Reuse launched application between tests, only set screen.
        _ = synchronousIpcClient.callOrFail(
            method: SetScreenIpcMethod(),
            arguments: SetScreenIpcMethod.Screen(
                viewType: name
            )
        )
    }
}
