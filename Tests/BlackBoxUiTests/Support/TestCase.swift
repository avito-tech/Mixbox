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
    
    private(set) lazy var testCaseUtils: TestCaseUtils = self.reuseState {
        TestCaseUtils()
    }
    
    var testRunnerPermissions: ApplicationPermissionsSetter {
        return testCaseUtils.testRunnerPermissions
    }
    
    var permissions: ApplicationPermissionsSetter {
        return testCaseUtils.permissions
    }
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    var ipcClient: IpcClient {
        return testCaseUtils.lazilyInitializedIpcClient
    }
    
    func precondition() {
    }
    
    override func setUp() {
        super.setUp()
        
        // Fail faster on CI
        let isCiBuild = ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"
        continueAfterFailure = !isCiBuild
        
        logEnvironment()
        
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
        // Note that setting it to a value > Int32.max would lead to an error.
        let timeoutValueThatReallyDisablesTimeout: TimeInterval = 100000
        SBTUITunneledApplication.setConnectionTimeout(timeoutValueThatReallyDisablesTimeout)
        
        let app = SBTUITunneledApplication()
        for (key, value) in commonEnvironment {
            app.launchEnvironment[key] = value
        }
        for (key, value) in environment {
            app.launchEnvironment[key] = value
        }
        app.launchTunnel { [applicationDidLaunchObservable=testCaseUtils.applicationDidLaunchObservable] in
            applicationDidLaunchObservable.applicationDidLaunch()
        }
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = SbtuiIpcClient(
            application: app
        )
    }
    
    private var commonEnvironment: [String: String] {
        return [
            // Just an assertion
            "MIXBOX_SHOULD_ADD_ASSERTION_FOR_CALLING_IS_HIDDEN_ON_FAKE_CELL": "true",
            // Fixes assertion failure when view is loaded multiple times and uses ViewIpc
            "MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY": "true",
            // TODO: What is it for? Is it just a default screen?
            "MB_TESTS_screenName": "DummyForLaunchingUiTestsView",
        ]
    }
    
    private func launchUsingBuiltinIpc(environment: [String: String]) {
        let app: XCUIApplication
        
        // Prototype of fast launching
        if !TestCase.everLaunched {
            app = XCUIApplication()
        } else {
            app = XCUIApplication(privateWithPath: nil, bundleID: "mixbox.Tests.TestedApp")
        }
        
        // Initialize client/server pairs
        let handshaker = KnownPortHandshakeWaiter()
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
        testCaseUtils.applicationDidLaunchObservable.applicationDidLaunch()
        
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
    
    private func logEnvironment() {
        let device = UIDevice.mb_platformType.rawValue
        let os = UIDevice.current.mb_iosVersion.majorAndMinor
        
        testCaseUtils.stepLogger.logEntry(
            description: "Started test with environment",
            artifacts: [
                Artifact(
                    name: "Environment",
                    content: .text(
                        """
                        Device: \(device)
                        OS: iOS \(os)
                        """
                    )
                )
            ]
        )
    }
    
    // MARK: - Gathering failures
    
    // TODO: Share by moving to Mixbox?
    
    private enum RecordFailureMode {
        case failTest
        case gatherFailures
    }
    
    private var recordFailureMode = RecordFailureMode.failTest
    private var gatheredFailures = [XcTestFailure]()
    
    func gatherFailures<T>(body: () -> (T)) -> GatherFailuresResult<T> {
        let saved_recordFailureMode = recordFailureMode
        let saved_gatheredFailures = gatheredFailures
        
        recordFailureMode = .gatherFailures
        gatheredFailures = []
        
        let bodyResult: GatherFailuresResult<T>.BodyResult = ObjectiveCExceptionCatcher.catch(
            try: {
                return .finished(body())
            },
            catch: { exception in
                if exception is TestCanNotBeContinuedException {
                    return .testFailedAndCannotBeContinued
                } else {
                    return .caughtException(exception)
                }
            },
            finally: {
            }
        )
        
        let failures = gatheredFailures
        
        gatheredFailures = saved_gatheredFailures + gatheredFailures
        recordFailureMode = saved_recordFailureMode
        
        return GatherFailuresResult(
            bodyResult: bodyResult,
            failures: failures
        )
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
            // Helpful addition for JUnit:
            let device = UIDevice.mb_platformType.rawValue
            let os = UIDevice.current.mb_iosVersion.majorAndMinor
            let environment = "\(device), iOS \(os)"
            
            // Note that you can set a breakpoint here (it is very convenient):
            super.recordFailure(
                withDescription: "\(environment): \(failure.description)",
                inFile: failure.file,
                atLine: failure.line,
                expected: failure.expected
            )
        case .gatherFailures:
            gatheredFailures.append(failure)
            
            if !continueAfterFailure {
                TestCanNotBeContinuedException().raise()
            }
        }
    }
    
    // MARK: - Recording logs & failures
    
    func recordLogsAndFailuresWithBodyResult<T>(body: () -> (T)) -> LogsAndFailuresWithBodyResult<T> {
        let gatheredData = recordLogs {
            gatherFailures(body: body)
        }
        
        return LogsAndFailuresWithBodyResult<T>(
            bodyResult: gatheredData.bodyResult.bodyResult,
            logs: gatheredData.logs,
            failures: gatheredData.bodyResult.failures
        )
    }
    
    func recordLogsAndFailures(body: () -> ()) -> LogsAndFailures {
        return recordLogsAndFailuresWithBodyResult(body: body).withoutBodyResult()
    }
    
    // MARK: - Recording logs
    
    func recordLogs<T>(body: () -> (T)) -> (bodyResult: T, logs: [StepLog]) {
        let recording = Singletons.stepLoggerRecordingStarter.startRecording()
        
        let bodyResult = body()
        
        recording.stopRecording()
        
        return (bodyResult: bodyResult, logs: recording.stepLogs)
    }
    
    // MARK: - Reusing state
    
    var reuseState: Bool {
        return true
    }
    
    private func reuseState<T>(file: StaticString = #file, line: UInt = #line, block: () -> (T)) -> T {
        // TODO: Make it work!
        let itWorksAsExpectedOnCi = false
        
        // TODO: Class for envs
        let isCiBuild = ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"

        let reusingStateIsImpossible = isCiBuild && !itWorksAsExpectedOnCi
        
        if reuseState && !reusingStateIsImpossible {
            let fileLine = FileLine(file: file, line: line)
            return TestStateRecycling.instance.reuseState(testCase: type(of: self), fileLine: fileLine) {
                block()
            }
        } else  {
            return block()
        }
    }
    
}
