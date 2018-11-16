public protocol TestLifecycleObservable: class {
    func addObserver(_ testLifecycleObserver: TestLifecycleObserver)
}

public final class TestLifecycleObservableImpl: TestLifecycleObservable {
    private var testObservations = [TestLifecycleObserverTestObservation]()
    
    public init() {
    }
    
    deinit {
        for testObservation in testObservations {
            XCTestObservationCenter.shared.removeTestObserver(testObservation)
        }
    }
    
    public func addObserver(_ testLifecycleObserver: TestLifecycleObserver) {
        let testObservation = TestLifecycleObserverTestObservation(
            testLifecycleObserver: testLifecycleObserver
        )
        testObservations.append(testObservation)
        XCTestObservationCenter.shared.addTestObserver(testObservation)
    }
}

public final class TestLifecycleObserverTestObservation: NSObject, XCTestObservation {
    private let testLifecycleObserver: TestLifecycleObserver
    
    public init(testLifecycleObserver: TestLifecycleObserver) {
        self.testLifecycleObserver = testLifecycleObserver
    }
    
    // MARK: - XCTestObservation
    
    // NOTE: @objc was added as a workaround for https://bugs.swift.org/browse/SR-2817
    // https://stackoverflow.com/questions/39495773/xcode-8-warning-instance-method-nearly-matches-optional-requirement
    
    @objc(testBundleWillStart:)
    public func testBundleWillStart(
        _ testBundle: Bundle)
    {
        testLifecycleObserver.testBundleObserver.onStart?(testBundle)
    }
    
    @objc(testBundleDidFinish:)
    public func testBundleDidFinish(
        _ testBundle: Bundle)
    {
        testLifecycleObserver.testBundleObserver.onStop?(testBundle)
    }
    
    @objc(testSuiteWillStart:)
    public func testSuiteWillStart(
        _ testSuite: XCTestSuite)
    {
        testLifecycleObserver.testSuiteObserver.onStart?(testSuite)
    }
    
    @objc(testSuite:didFailWithDescription:inFile:atLine:)
    public func testSuite(
        _ testSuite: XCTestSuite,
        didFailWithDescription description: String,
        inFile filePath: String?,
        atLine lineNumber: Int)
    {
        testLifecycleObserver.testSuiteObserver.onFail?(
            testSuite,
            description,
            filePath,
            lineNumber
        )
    }
    
    @objc(testSuiteDidFinish:)
    public func testSuiteDidFinish(
        _ testSuite: XCTestSuite)
    {
        testLifecycleObserver.testSuiteObserver.onStop?(testSuite)
    }
    
    @objc(testCaseWillStart:)
    public func testCaseWillStart(
        _ testCase: XCTestCase)
    {
        testLifecycleObserver.testCaseObserver.onStart?(testCase)
    }
    
    @objc(testCase:didFailWithDescription:inFile:atLine:)
    public func testCase(
        _ testCase: XCTestCase,
        didFailWithDescription description: String,
        inFile filePath: String?,
        atLine lineNumber: Int)
    {
        testLifecycleObserver.testCaseObserver.onFail?(
            testCase,
            description,
            filePath,
            lineNumber
        )
    }
    
    @objc(testCaseDidFinish:)
    public func testCaseDidFinish(
        _ testCase: XCTestCase)
    {
        testLifecycleObserver.testCaseObserver.onStop?(testCase)
    }
}
