import Foundation

public final class TestLifecycleObserverTestObservation: NSObject, XCTestObservation {
    private let testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver
    private let testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver
    private let testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver
    
    public init(
        testLifecycleTestBundleObserver: TestLifecycleTestBundleObserver,
        testLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver,
        testLifecycleTestCaseObserver: TestLifecycleTestCaseObserver
    ) {
        self.testLifecycleTestBundleObserver = testLifecycleTestBundleObserver
        self.testLifecycleTestSuiteObserver = testLifecycleTestSuiteObserver
        self.testLifecycleTestCaseObserver = testLifecycleTestCaseObserver
    }
    
    // MARK: - XCTestObservation
    
    // NOTE: @objc was added as a workaround for https://bugs.swift.org/browse/SR-2817
    // https://stackoverflow.com/questions/39495773/xcode-8-warning-instance-method-nearly-matches-optional-requirement
    
    @objc(testBundleWillStart:)
    public func testBundleWillStart(
        _ testBundle: Bundle)
    {
        testLifecycleTestBundleObserver.onStart(testBundle: testBundle)
    }
    
    @objc(testBundleDidFinish:)
    public func testBundleDidFinish(
        _ testBundle: Bundle)
    {
        testLifecycleTestBundleObserver.onStop(testBundle: testBundle)
    }
    
    @objc(testSuiteWillStart:)
    public func testSuiteWillStart(
        _ testSuite: XCTestSuite)
    {
        testLifecycleTestSuiteObserver.onStart(testSuite: testSuite)
    }
    
    @objc(testSuite:didFailWithDescription:inFile:atLine:)
    public func testSuite(
        _ testSuite: XCTestSuite,
        didFailWithDescription description: String,
        inFile filePath: String?,
        atLine lineNumber: Int)
    {
        testLifecycleTestSuiteObserver.onFail(
            testSuite: testSuite,
            description: description,
            filePath: filePath,
            lineNumber: lineNumber
        )
    }
    
    @objc(testSuiteDidFinish:)
    public func testSuiteDidFinish(
        _ testSuite: XCTestSuite)
    {
        testLifecycleTestSuiteObserver.onStop(testSuite: testSuite)
    }
    
    @objc(testCaseWillStart:)
    public func testCaseWillStart(
        _ testCase: XCTestCase)
    {
        testLifecycleTestCaseObserver.onStart(testCase: testCase)
    }
    
    @objc(testCase:didFailWithDescription:inFile:atLine:)
    public func testCase(
        _ testCase: XCTestCase,
        didFailWithDescription description: String,
        inFile filePath: String?,
        atLine lineNumber: Int)
    {
        testLifecycleTestCaseObserver.onFail(
            testCase: testCase,
            description: description,
            filePath: filePath,
            lineNumber: lineNumber
        )
    }
    
    @objc(testCaseDidFinish:)
    public func testCaseDidFinish(
        _ testCase: XCTestCase)
    {
        testLifecycleTestCaseObserver.onStop(testCase: testCase)
    }
}
