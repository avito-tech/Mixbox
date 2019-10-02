import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxArtifacts
import MixboxReporting
import MixboxIpc
import MixboxFoundation

class BaseUiTestCase: XCTestCase, FailureGatherer {
    private(set) lazy var testCaseUtils: TestCaseUtils = self.reuseState {
        TestCaseUtils()
    }
    
    var waiter: RunLoopSpinningWaiter {
        return testCaseUtils.baseUiTestCaseUtils.waiter
    }
    
    var permissions: ApplicationPermissionsSetter {
        return testCaseUtils.permissions
    }
    
    var pageObjects: PageObjects {
        return testCaseUtils.pageObjects
    }
    
    var ipcClient: IpcClient {
        return testCaseUtils.baseUiTestCaseUtils.lazilyInitializedIpcClient
    }
    
    var legacyNetworking: LegacyNetworking {
        return testCaseUtils.legacyNetworking
    }
    
    var fileSystem: FileSystem {
        return testCaseUtils.baseUiTestCaseUtils.fileSystem
    }
    
    var photoStubber: PhotoStubber {
        return testCaseUtils.photoStubber
    }
    
    private var baseClassPreconditionWasCalled = false
    func precondition() {
        baseClassPreconditionWasCalled = true
    }
    
    override func setUp() {
        super.setUp()
        
        // Fail faster on CI
        let isCiBuild = ProcessInfo.processInfo.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"
        continueAfterFailure = !isCiBuild
        
        logEnvironment()
        
        reuseState {
            precondition()
            XCTAssertEqual(baseClassPreconditionWasCalled, true)
        }
    }
    
    private func logEnvironment() {
        let device = UIDevice.mb_platformType.rawValue
        let os = UIDevice.current.mb_iosVersion.majorAndMinor
        
        testCaseUtils.baseUiTestCaseUtils.stepLogger.logEntry(
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
    
    func image(name: String) -> UIImage {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: nil),
            let image = UIImage(contentsOfFile: path) else
        {
            UnavoidableFailure.fail("Couldn't load image '\(name)'")
        }
        
        return image
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
                .finished(body())
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
        let fileLine = testCaseUtils.baseUiTestCaseUtils.fileLineForFailureProvider.fileLineForFailure()
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
