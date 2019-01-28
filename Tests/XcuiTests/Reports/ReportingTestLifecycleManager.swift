import MixboxTestsFoundation
import MixboxArtifacts
import XCTest
import MixboxReporting

public final class ReportingTestLifecycleManager:
    TestLifecycleManager
{
    public let stepLogsProvider: StepLogsProvider
    private let reportingSystem: AsyncReportingSystem
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        reportingSystem: ReportingSystem,
        stepLogsProvider: StepLogsProvider,
        testFailureRecorder: TestFailureRecorder)
    {
        self.reportingSystem = AsyncReportingSystem(
            reportingSystem: reportingSystem
        )
        self.stepLogsProvider = stepLogsProvider
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
            // Уберем потом логи, хочу знать какой таймаут выбрать. (TODO: Убрать логи)
            // Результат одного из прогонов: Ожидание загрузки репортов: 3.84899699687958 секунд
            let startDate = Date()
            
            let timeout: TimeInterval = 60
            self?.reportingSystem.waitForLastReportBeingSent(timeout: timeout)
            
            let stopDate = Date()
            let actualTime = stopDate.timeIntervalSince(startDate)
            print("Ожидание загрузки репортов: \(actualTime) секунд")
        }
        
        testLifecycleObservable.addObserver(testLifecycleObserver)
    }
    
    // MARK: - Event handling
    
    private func handleTestSuiteStarted(testSuite: XCTestSuite) {
        currentTestSuiteState = CurrentTestSuiteState(startDate: Date())
    }
    
    private func handleTestSuiteStopped(testSuite: XCTestSuite) {
        // XCTestSuite не всегда является представлением XCTestCase, поэтому в конце может
        // 3 раза прийти стоп тестов
        //
        // Test Suite 'AbuseTest' passed at 2018-01-23 17:53:28.935.
        // Executed 1 test, with 0 failures (0 unexpected) in 46.561 (46.571) seconds
        // Test Suite 'FunctionalTests.xctest' passed at 2018-01-23 17:53:29.218.
        // Executed 3 tests, with 0 failures (0 unexpected) in 139.655 (450.312) seconds
        // Test Suite 'Selected tests' passed at 2018-01-23 18:09:02.690.
        // Executed 3 tests, with 0 failures (0 unexpected) in 139.655 (895.452) seconds
        //
        // Пока просто записывается последний завершенный (AbuseTests_91943),
        // сбрасывается стейт текущего сьюта и остальные игнорятся.
        
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
        
        stepLogsProvider.cleanLogs()
        
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
        // Думаю, что если степ зафейлился и управление выкинуло из invokeTest у XCTestCase,
        // то так можно поставить ему длительность 0. Можно еще подумать.
        let stopDate = stepLog.stopDate ?? stepLog.startDate
        
        return TestStepReport(
            uuid: NSUUID(),
            name: stepLog.identifyingDescription,
            description: stepLog.detailedDescription,
            type: stepLog.stepType,
            status: stepLog.wasSuccessful ? .passed : .failed,
            steps: stepLog.steps.compactMap(testStepReport),
            startDate: stepLog.startDate,
            stopDate: stopDate,
            attachments: (stepLog.artifactsBefore + stepLog.artifactsAfter).map { TestReportAttachment(artifact: $0) }
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
