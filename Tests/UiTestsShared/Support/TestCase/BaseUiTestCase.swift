import XCTest
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit

class BaseUiTestCase: XCTestCase, FailureGatherer {
    private(set) lazy var dependencies: TestCaseDependenciesResolver = self.reuseState {
        makeDependencies()
    }
    
    func makeDependencies() -> TestCaseDependenciesResolver {
        UnavoidableFailure.fail("\(#function) should be implemented in a subclass of \(BaseUiTestCase.self)")
    }
    
    private var recordingFailureRecursionCounter = 0
    private let recordingFailureRecursionCounterThreshold = 10
    
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
            
            assertPreconditionInSuperClassIsCalled()
        }
    }
    
    private func logEnvironment() {
        let device = UIDevice.mb_platformType.rawValue
        let os = iosVersionProvider.iosVersion().majorAndMinor
        
        stepLogger.logEntry(
            date: dateProvider.currentDate(),
            title: "Started test with environment",
            attachments: [
                Attachment(
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
    
    private func assertPreconditionInSuperClassIsCalled() {
        if !baseClassPreconditionWasCalled {
            testFailureRecorder.recordFailure(
                description:
                """
                You must call super.precondition() from your subclass \
                of \(BaseUiTestCase.self) (\(type(of: self)))
                """,
                shouldContinueTest: false
            )
        }
    }
    
    // MARK: - Loading resources
    
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
        recordingFailureRecursionCounter += 1
        defer {
            recordingFailureRecursionCounter -= 1
        }
        
        guard recordingFailureRecursionCounter < recordingFailureRecursionCounterThreshold else {
            // Might happen if DI fails, for example.
            // Because `else` case can contain logic that might call `recordFailure`.
            super.recordFailure(
                withDescription: "Went to recursion, current failure: \(description)",
                inFile: filePath,
                atLine: lineNumber,
                expected: expected
            )
            return
        }
        
        let fileLineForFailureProvider: FileLineForFailureProvider = dependencies.resolve()
        
        let fileLine = fileLineForFailureProvider.fileLineForFailure()
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
            let os = iosVersionProvider.iosVersion().majorAndMinor
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
