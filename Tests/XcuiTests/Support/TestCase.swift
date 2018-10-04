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

class TestCase: XCTestCase, FailureGatherer {
    // Prototype of fast launching, see usage:
    // UPD: Implemented in Avito. TODO: Sync with Mixbox.
    static var everLaunched = false
    
    private(set) lazy var testCaseUtils: TestCaseUtils = self.reuseState { TestCaseUtils() }
    
    var testRunnerPermissions: ApplicationPermissionsSetter {
        return testCaseUtils.testRunnerPermissions
    }
    
    var permissions: ApplicationPermissionsSetter {
        return testCaseUtils.permissions
    }
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    func precondition() {
    }
    
    override func setUp() {
        super.setUp()
        
        testCaseUtils.currentTestCaseProvider.setCurrentTestCase(self)
        
        reuseState {
            precondition()
        }
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
    
    private func launchUsingBuiltinIpc(environment: [String: String]) {
        let app: XCUIApplication
        
        // Prototype of fast launching
        if !TestCase.everLaunched {
            app = XCUIApplication()
        } else {
            app = XCUIApplication(privateWithPath: nil, bundleID: "mixbox.XcuiTests.app")
        }
        
        // Initialize client/server pairs
        let handshaker = Handshaker()
        guard let port = handshaker.start() else {
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
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = handshaker.waitForHandshake()
        testCaseUtils.ipcRouter = handshaker.server
    }
    
    func openScreen(name: String, useBuiltinIpc: Bool = false) {
        launch(
            environment: [
                "MB_TESTS_screenName": name
            ],
            useBuiltinIpc: useBuiltinIpc
        )
    }
    
    // MARK: - Gathering failures
    
    private enum RecordFailureMode {
        case failTest
        case gatherFailures
    }
    
    private var recordFailureMode = RecordFailureMode.failTest
    private var gatheredFailures = [XcTestFailure]()
    func gatherFailures(_ body: () -> ()) -> [XcTestFailure] {
        let saved_recordFailureMode = recordFailureMode
        let saved_gatheredFailures = gatheredFailures
        
        recordFailureMode = .gatherFailures
        gatheredFailures = []
        
        body()
        
        let valueToReturn = gatheredFailures
        
        gatheredFailures = saved_gatheredFailures + gatheredFailures
        recordFailureMode = saved_recordFailureMode
        
        return valueToReturn
    }
    
    override func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool)
    {
        let fileLine = testCaseUtils.fileLineForFailureProvider.fileLineForFailure()
            ?? HeapFileLine(file: filePath, line: UInt64(lineNumber))
        
        let failure = XcTestFailure(
            description: description,
            file: fileLine.file,
            line: Int(fileLine.line),
            expected: expected
        )
        
        switch recordFailureMode {
        case .failTest:
            // Note that you can set a breakpoint here (it is very convenient):
            super.recordFailure(
                withDescription: failure.description,
                inFile: failure.file,
                atLine: failure.line,
                expected: failure.expected
            )
        case .gatherFailures:
            gatheredFailures.append(failure)
        }
    }
    
    // MARK: - Reusing state
    
    var reuseState: Bool {
        return true
    }
    
    private func reuseState<T>(file: StaticString = #file, line: UInt = #line, block: () -> (T)) -> T {
        if reuseState {
            let fileLine = FileLine(file: file, line: line)
            return TestStateRecycling.instance.reuseState(testCase: type(of: self), fileLine: fileLine) {
                block()
            }
        } else  {
            return block()
        }
    }
    
}
