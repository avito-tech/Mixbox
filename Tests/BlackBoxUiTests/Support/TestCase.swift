import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxXcuiDriver
import MixboxArtifacts
import SBTUITestTunnel
import MixboxIpcSbtuiClient
import MixboxReporting
import MixboxBuiltinIpc
import MixboxIpc
import MixboxFoundation

class TestCase: BaseUiTestCase, ScreenOpener {
    // Prototype of fast launching, see usage:
    // UPD: Implemented in Avito. TODO: Sync with Mixbox.
    static var everLaunched = false
    
    var testRunnerPermissions: ApplicationPermissionsSetter {
        return testCaseUtils.testRunnerPermissions
    }
    
    func launch(environment: [String: String], useBuiltinIpc: Bool = false) {
        let commonEnvironment = [
            // Just an assertion
            "MIXBOX_SHOULD_ADD_ASSERTION_FOR_CALLING_IS_HIDDEN_ON_FAKE_CELL": "true",
            // Fixes assertion failure when view is loaded multiple times and uses ViewIpc
            "MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY": "true",
            // TODO: What is it for? Is it just a default screen?
            "MB_TESTS_screenName": "DummyForLaunchingUiTestsView"
        ]
        
        var mergedEnvironment = commonEnvironment
        
        for (key, value) in environment {
            mergedEnvironment[key] = value
        }
        
        testCaseUtils.launchableApplicationProvider.shouldCreateLaunchableApplicationWithBuiltinIpc = useBuiltinIpc
        
        let launchedApplication = testCaseUtils
            .launchableApplicationProvider
            .launchableApplication
            .launch(arguments: [], environment: mergedEnvironment)
        
        testCaseUtils.baseUiTestCaseUtils.lazilyInitializedIpcClient.ipcClient = launchedApplication.ipcClient
        testCaseUtils.ipcRouter = launchedApplication.ipcRouter
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
