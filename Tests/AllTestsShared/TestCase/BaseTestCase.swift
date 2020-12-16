import XCTest
import MixboxTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxUiKit
import MixboxDi
import MixboxBuiltinDi
import TestsIpc
import MixboxMocksRuntime

class BaseTestCase: TestCaseSuppressingWarningAboutDeprecatedRecordFailure, FailureGatherer {
    private var tearDownAction: TearDownAction?
    private let mocksDependencyInjection = BuiltinDependencyInjection()
    
    // This enables mocking dependencies (improves testability).
    var mocks: DependencyRegisterer {
        return mocksDependencyInjection
    }
    
    // TODO: Rename to `di`, it's shorter and nicer.
    private(set) lazy var dependencies: TestFailingDependencyResolver = self.reuseState {
        let configuration = dependencyInjectionConfiguration()

        let dependencyInjectionFactory = BuiltinDependencyInjectionFactory()
        
        let defaultDependencyInjection = dependencyInjectionFactory.dependencyInjection()
        
        defaultDependencyInjection.register(type: DependencyInjectionFactory.self) { _ in
            dependencyInjectionFactory
        }
        defaultDependencyInjection.register(type: PerformanceLogger.self) { _ in
            configuration.performanceLogger
        }
        
        return TestCaseDi.make(
            dependencyCollectionRegisterer: configuration.dependencyCollectionRegisterer,
            dependencyInjection: DelegatingDependencyInjection(
                dependencyResolver: PerformanceLoggingDependencyResolver(
                    dependencyResolver: DelegatingDependencyInjection(
                        dependencyResolver: CompoundDependencyResolver(
                            resolvers: [
                                mocksDependencyInjection,
                                defaultDependencyInjection
                            ]
                        ),
                        dependencyRegisterer: defaultDependencyInjection
                    ),
                    performanceLogger: configuration.performanceLogger
                ),
                dependencyRegisterer: defaultDependencyInjection
            )
        )
    }
    
    final class DependencyInjectionConfiguration {
        let dependencyCollectionRegisterer: DependencyCollectionRegisterer
        let performanceLogger: PerformanceLogger
        
        init(
            dependencyCollectionRegisterer: DependencyCollectionRegisterer,
            performanceLogger: PerformanceLogger = NoopPerformanceLogger())
        {
            self.dependencyCollectionRegisterer = dependencyCollectionRegisterer
            self.performanceLogger = performanceLogger
        }
    }
    
    // Overrideable!
    func dependencyInjectionConfiguration() -> DependencyInjectionConfiguration {
        UnavoidableFailure.fail("\(#function) should be implemented in a subclass of \(BaseTestCase.self)")
    }
    
    // Overrideable!
    func setUpActions() -> [SetUpAction] {
        return [
            LogEnvironmentSetUpAction(
                dateProvider: dateProvider,
                stepLogger: stepLogger,
                iosVersionProvider: iosVersionProvider
            ),
            RegisterMocksSetUpAction(
                testCase: self,
                mockRegisterer: dependencies.resolve()
            )
        ]
    }
    
    private func setUpAction() -> SetUpAction {
        return CompoundSetUpAction(
            setUpActions: setUpActions()
        )
    }
    
    func register<M: Mock>(_ mock: M) -> M {
        (dependencies.resolve() as MockRegisterer).register(mock: mock)
        
        return mock
    }
    
    private var recordingFailureRecursionCounter = 0
    private let recordingFailureRecursionCounterThreshold = 10
    
    // TODO: Add precondition for tests that reuse state. We may also get rid of `reuseState` property.
    // E.g. use `precondition` and `reusedPrecondition` method. If `reusedPrecondition` is implemented it should
    // act like `reuseState` is `true`, `reuseState` can be removed then. It is useful to have both method implemented.
    // Example:
    //
    // override func precondition() {
    //     resetUi()
    // }
    //
    // override func reusablePrecondition() {
    //     screen.open()
    // }
    //
    private var baseClassPreconditionWasCalled = false
    func precondition() {
        baseClassPreconditionWasCalled = true
    }
    
    override func setUp() {
        super.setUp()
        
        // Fail faster on CI
        let isCiBuild = environmentProvider.environment["MIXBOX_CI_IS_CI_BUILD"] == "true"
        continueAfterFailure = !isCiBuild
        
        tearDownAction = setUpAction().setUp()
        
        reuseState {
            precondition()
            
            assertPreconditionInSuperClassIsCalled()
        }
    }
    
    override func tearDown() {
        tearDownAction?.tearDown()
        
        uninterceptableErrorTrackerImpl.recordFailures(testCase: self)
        
        super.tearDown()
    }
    
    private func logEnvironment() {
    }
    
    private func assertPreconditionInSuperClassIsCalled() {
        if !baseClassPreconditionWasCalled {
            testFailureRecorder.recordFailure(
                description:
                """
                You must call super.precondition() from your subclass \
                of \(BaseTestCase.self) (\(type(of: self)))
                """,
                shouldContinueTest: false
            )
        }
    }
    
    // MARK: - Gathering failures
    
    // TODO: Share by moving to Mixbox?
    
    private enum RecordFailureMode {
        case failTest
        case gatherFailures
    }
    
    var uninterceptableErrorTracker: UninterceptableErrorTracker {
        return uninterceptableErrorTrackerImpl
    }
    
    private let uninterceptableErrorTrackerImpl = UninterceptableErrorTrackerImpl()
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
        inFile file: String,
        atLine line: Int,
        expected: Bool)
    {
        let line: UInt = SourceCodeLineTypeConverter.convert(line: line)
        
        recordingFailureRecursionCounter += 1
        defer {
            recordingFailureRecursionCounter -= 1
        }
        
        guard recordingFailureRecursionCounter < recordingFailureRecursionCounterThreshold else {
            // Might happen if DI fails, for example.
            // Because `else` case can contain logic that might call `recordFailure`.
            
            self.recordFailureBySuper(
                description: description,
                file: file,
                line: line,
                expected: expected
            )
            return
        }
        
        let fileLineForFailureProvider: FileLineForFailureProvider = dependencies.resolve()
        
        let fileLine = fileLineForFailureProvider.fileLineForFailure()
            ?? RuntimeFileLine(
                file: file,
                line: line
            )
        
        let failure = XcTestFailure(
            description: description,
            file: fileLine.file,
            line: fileLine.line,
            expected: expected
        )
        
        switch recordFailureMode {
        case .failTest:
            // Helpful addition for JUnit:
            let device = UIDevice.mb_platformType.rawValue
            let os = iosVersionProvider.iosVersion().majorAndMinor
            let environment = "\(device), iOS \(os)"
            
            // Note that you can set a breakpoint here (it is very convenient):
            super.recordFailureBySuper(
                description: "\(environment): \(failure.description)",
                file: failure.file,
                line: failure.line,
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
        let stepLoggerRecordingStarter = dependencies.resolve() as StepLoggerRecordingStarter
        let recording = stepLoggerRecordingStarter.startRecording()
        
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
        
        // `environmentProvider` can not be used, because it will cause recursion.
        // And this is not needed here.
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
