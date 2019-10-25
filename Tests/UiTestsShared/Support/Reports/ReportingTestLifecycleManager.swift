import XCTest
import MixboxTestsFoundation

public final class ReportingTestLifecycleManager:
    TestLifecycleManager
{
    public let stepLogsProvider: StepLogsProvider
    
    private let reportingSystem: AsyncReportingSystem
    private let stepLogsCleaner: StepLogsCleaner
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        reportingSystem: ReportingSystem,
        stepLogsProvider: StepLogsProvider,
        stepLogsCleaner: StepLogsCleaner,
        testFailureRecorder: TestFailureRecorder)
    {
        self.reportingSystem = AsyncReportingSystem(
            reportingSystem: reportingSystem
        )
        self.stepLogsProvider = stepLogsProvider
        self.stepLogsCleaner = stepLogsCleaner
        self.testFailureRecorder = testFailureRecorder
    }
    
    private final class CurrentTestState {
        var isFlaky = false
        var startDate: Date
        var failures = [TestReportFailure]()
        
        init(startDate: Date) {
            self.startDate = startDate
        }
        
        func resetBeforeStart() {
            resetBeforeTry()
            
            startDate = Date()
            failures.removeAll()
        }
        
        func resetBeforeTry() {
            isFlaky = false
        }
    }
    
    private final class CurrentTestSuiteState {
        var testMethodReports = [TestMethodReport]()
        var testCaseClassName: String?
        var startDate: Date
        
        init(startDate: Date) {
            self.startDate = startDate
        }
    }
    
    private var currentTestState = CurrentTestState(startDate: Date())
    private var currentTestSuiteState = CurrentTestSuiteState(startDate: Date())
    
    // MARK: - TestLifecycleManager
    
    public func startObserving(testLifecycleObservable: TestLifecycleObservable) {
        let testLifecycleObserver = TestLifecycleObserver()
        
        testLifecycleObserver.testSuiteObserver.onStart = { [weak self] testSuite in
            self?.handleTestSuiteStarted(testSuite: testSuite)
        }
        
        testLifecycleObserver.testSuiteObserver.onStop = { [weak self] testSuite in
            self?.handleTestSuiteStopped(testSuite: testSuite)
        }
        
        testLifecycleObserver.testCaseObserver.onStart = { [weak self] testCase in
            self?.handleTestMethodStarted(testCase: testCase)
        }
        
        testLifecycleObserver.testCaseObserver.onStop = { [weak self] testCase in
            self?.handleTestMethodStopped(testCase: testCase)
        }
        
        testLifecycleObserver.testCaseObserver.onFail = { [weak self] testCase, description, file, line in
            self?.handleTestMethodFailed(
                testCase: testCase,
                description: description,
                file: file,
                line: line
            )
        }
        
        testLifecycleObserver.testBundleObserver.onStop = { [weak self] testCase in
            let startDate = Date()
            
            let timeout: TimeInterval = 60
            self?.reportingSystem.waitForLastReportBeingSent(timeout: timeout)
            
            let stopDate = Date()
            let actualTime = stopDate.timeIntervalSince(startDate)
            print("Waiting for reports being sent: \(actualTime) seconds")
        }
        
        testLifecycleObservable.addObserver(testLifecycleObserver)
    }
    
    // MARK: - Event handling
    
    private func handleTestSuiteStarted(testSuite: XCTestSuite) {
        currentTestSuiteState = CurrentTestSuiteState(startDate: Date())
    }
    
    private func handleTestSuiteStopped(testSuite: XCTestSuite) {
        // XCTestSuite is not always represents XCTestCase, so at the end of tests "stop" event can
        // be received 3 times:
        //
        // Test Suite 'MyCoolFeatureTests' passed at 2018-01-23 17:53:28.935.
        // Executed 1 test, with 0 failures (0 unexpected) in 46.561 (46.571) seconds
        // Test Suite 'FunctionalTests.xctest' passed at 2018-01-23 17:53:29.218.
        // Executed 3 tests, with 0 failures (0 unexpected) in 139.655 (450.312) seconds
        // Test Suite 'Selected tests' passed at 2018-01-23 18:09:02.690.
        // Executed 3 tests, with 0 failures (0 unexpected) in 139.655 (895.452) seconds
        //
        // Current simple implementation remembers last finished test (MyCoolFeatureTests),
        // drops state of current test suite and other callbacks are ignored.
        
        guard !currentTestSuiteState.testMethodReports.isEmpty else {
            return
        }
        
        let status = currentTestSuiteState.testMethodReports.reduce(TestReportStatus.passed) { result, report in
            switch report.status {
            case .passed:
                return result
            case .failed:
                return .failed
            case .manual:
                return .manual
            case .error:
                return .error
            }
        }
        
        // TODO: Deterministic IDs?
        
        let testCaseReport = TestCaseReport(
            uuid: NSUUID(),
            testCaseClassName: currentTestSuiteState.testCaseClassName,
            testMethods: currentTestSuiteState.testMethodReports,
            status: status,
            startDate: testSuite.testRun?.startDate ?? currentTestSuiteState.startDate,
            stopDate: testSuite.testRun?.stopDate ?? Date()
        )
        
        reportingSystem.reportTestCase(testCaseReport: testCaseReport) {}
        
        currentTestSuiteState = CurrentTestSuiteState(startDate: Date())
    }
    
    private func handleTestMethodStarted(testCase: XCTestCase) {
        currentTestState.resetBeforeStart()
        currentTestState.startDate = Date()
    }
    
    private func handleTestMethodStopped(testCase: XCTestCase) {
        let xcTestCaseName = self.xcTestCaseName(testCase: testCase)
        
        currentTestSuiteState.testCaseClassName = xcTestCaseName?.className
        
        let testMethodReport = TestMethodReport(
            uuid: NSUUID(),
            uniqueName: xcTestCaseName?.fullName,
            testMethodName: xcTestCaseName?.methodName,
            testCaseClassName: xcTestCaseName?.className,
            status: status(testCase: testCase),
            isFlaky: currentTestState.isFlaky,
            startDate: testCase.testRun?.startDate ?? currentTestState.startDate,
            stopDate: testCase.testRun?.stopDate ?? Date(),
            steps: stepLogsProvider.stepLogs.map(testStepReport),
            failures: currentTestState.failures
        )
        
        currentTestSuiteState.testMethodReports.append(testMethodReport)
        
        stepLogsCleaner.cleanLogs()
        
        currentTestState.resetBeforeStart()
    }
    
    private func handleTestMethodFailed(
        testCase: XCTestCase,
        description: String,
        file: String?,
        line: Int)
    {
        currentTestState.failures.append(
            TestReportFailure(
                description: description,
                file: file ?? "<unknown file>",
                line: line
            )
        )
    }
    
    private func testStepReport(stepLog: StepLog) -> TestStepReport {
        // I think that if step is failed and `invokeTest` didn't finish properly (this is the case
        // when `stopDate` is nil) then it is okay to set the `stopDate` to `startDate` and thus the duration to nil.
        // Maybe there is a much better solution.
        let stopDate = stepLog.stopDate ?? stepLog.startDate
        
        return TestStepReport(
            uuid: NSUUID(),
            title: stepLog.title,
            status: stepLog.wasSuccessful ? .passed : .failed,
            steps: stepLog.steps.compactMap(testStepReport),
            startDate: stepLog.startDate,
            stopDate: stopDate,
            customDataBefore: stepLog.before.customData,
            customDataAfter: stepLog.after?.customData,
            attachments: (stepLog.attachmentsBefore + stepLog.attachmentsAfter).map {
                TestReportAttachment(attachment: $0)
            }
        )
    }
    
    // MARK: - Fields from events
    
    private func status(testCase: XCTestCase) -> TestReportStatus {
        switch testCase.testRun?.hasSucceeded {
        case true?:
            return .passed
        case false?:
            return .failed
        case nil:
            // Skipped?
            testFailureRecorder.recordFailure(
                description: "Unhandled status. Make AllureStatus for this case",
                shouldContinueTest: true
            )
            return .failed
        }
    }
    
    // MARK: - Data for fields
    
    private func xcTestCaseName(testCase: XCTestCase) -> XcTestCaseName? {
        let fullName = testCase.name
        
        var classNameOptional: NSString?
        var methodNameOptional: NSString?
        
        let scanner = Scanner(string: fullName)
        
        guard scanner.scanString("-[", into: nil),
            scanner.scanUpTo(" ", into: &classNameOptional),
            scanner.scanUpTo("]", into: &methodNameOptional),
            let className = classNameOptional,
            let methodName = methodNameOptional
            else
        {
            return nil
        }
        
        return XcTestCaseName(
            fullName: fullName,
            className: className as String,
            methodName: methodName as String
        )
    }
}

private struct XcTestCaseName {
    let fullName: String
    let className: String
    let methodName: String
}
