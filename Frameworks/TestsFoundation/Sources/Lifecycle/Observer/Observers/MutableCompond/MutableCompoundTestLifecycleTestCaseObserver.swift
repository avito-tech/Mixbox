public final class MutableCompoundTestLifecycleTestCaseObserver: TestLifecycleTestCaseObserver {
    public var testLifecycleTestCaseObservers: [TestLifecycleTestCaseObserver]
    
    public init(testLifecycleTestCaseObservers: [TestLifecycleTestCaseObserver] = []) {
        self.testLifecycleTestCaseObservers = testLifecycleTestCaseObservers
    }
    
    public func onStart(testCase: XCTestCase) {
        testLifecycleTestCaseObservers.forEach {
            $0.onStart(testCase: testCase)
        }
    }
    
    public func onStop(testCase: XCTestCase) {
        testLifecycleTestCaseObservers.forEach {
            $0.onStop(testCase: testCase)
        }
    }
    
    public func onFail(testCase: XCTestCase, description: String, filePath: String?, lineNumber: Int) {
        testLifecycleTestCaseObservers.forEach {
            $0.onFail(
                testCase: testCase,
                description: description,
                filePath: filePath,
                lineNumber: lineNumber
            )
        }
    }
}
