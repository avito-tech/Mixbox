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
    
    var networking: Networking {
        return testCaseUtils.launchableApplicationProvider.launchableApplication.networking
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
        let commonEnvironment = [
            // Just an assertion
            "MIXBOX_SHOULD_ADD_ASSERTION_FOR_CALLING_IS_HIDDEN_ON_FAKE_CELL": "true",
            // Fixes assertion failure when view is loaded multiple times and uses ViewIpc
            "MIXBOX_REREGISTER_SBTUI_IPC_METHOD_HANDLERS_AUTOMATICALLY": "true",
            // TODO: What is it for? Is it just a default screen?
            "MB_TESTS_screenName": "DummyForLaunchingUiTestsView",
        ]
        
        var mergedEnvironment = commonEnvironment
        
        for (key, value) in environment {
            mergedEnvironment[key] = value
        }
        
        testCaseUtils.launchableApplicationProvider.shouldCreateLaunchableApplicationWithBuiltinIpc = useBuiltinIpc
        
        let launchedApplication = testCaseUtils
            .launchableApplicationProvider
            .launchableApplication
            .launch(environment: mergedEnvironment)
        
        testCaseUtils.lazilyInitializedIpcClient.ipcClient = launchedApplication.ipcClient
        testCaseUtils.ipcRouter = launchedApplication.ipcRouter
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
