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

class TestCase: XCTestCase {
    // Prototype of fast launching, see usage:
    static var everLaunched = false
    
    let testCaseUtils = TestCaseUtils()
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    override func setUp() {
        super.setUp()
        
        testCaseUtils.currentTestCaseProvider.setCurrentTestCase(self)
    }
    
    func launch(environment: [String: String], useBuiltinIpc: Bool = false) {
        if useBuiltinIpc {
            launchUsingBuiltinIpc(environment: environment)
        } else {
            launchUsingSbtui(environment: environment)
        }
    }
    
    private func launchUsingSbtui(environment: [String: String]) {
        let app = SBTUITunneledApplication()
        for (key, value) in commonEnvironment {
            app.launchEnvironment[key] = value
        }
        for (key, value) in environment {
            app.launchEnvironment[key] = value
        }
        app.launchTunnel()
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = SbtuiIpcClient(
            application: app
        )
    }
    
    private var commonEnvironment: [String: String] {
        return [
            "MIXBOX_SHOULD_ADD_ASSERTION_FOR_CALLING_IS_HIDDEN_ON_FAKE_CELL": "true"
        ]
    }
    
    override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: Int, expected: Bool) {
        // For breakpoints:
        super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: expected)
    }
    
    private func launchUsingBuiltinIpc(environment: [String: String]) {
        let app: XCUIApplication
        
        // Prototype of fast launching
        if !TestCase.everLaunched {
            app = XCUIApplication()
        } else {
            app = XCUIApplication(privateWithPath: nil, bundleID: "mixbox.XcuiTests.app")
        }
        
        // Initialize client/server pairs
        let handshaking = Handshaker()
        guard let port = handshaking.start() else {
            preconditionFailure("Не удалось стартовать сервер.")
        }
        
        // Set up environment
        for (key, value) in commonEnvironment {
            app.launchEnvironment[key] = value
        }
        
        app.launchEnvironment["MIXBOX_HOST"] = "localhost"
        app.launchEnvironment["MIXBOX_PORT"] = "\(port)"
        app.launchEnvironment["MIXBOX_USE_BUILTIN_IPC"] = "true"
        
        for (key, value) in environment {
            app.launchEnvironment[key] = value
        }
        
        // Launch
        app.launch()
        TestCase.everLaunched = true
        
        // Wait for handshake
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = handshaking.waitForHandshake()
    }
    
    func openScreen(name: String) {
        launch(
            environment: [
                "MB_TESTS_screenName": name
            ]
        )
    }
}
