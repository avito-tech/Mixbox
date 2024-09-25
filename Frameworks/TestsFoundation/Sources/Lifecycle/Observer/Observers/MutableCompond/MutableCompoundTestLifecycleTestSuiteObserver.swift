import XCTest

public final class MutableCompoundTestLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver {
    public var testLifecycleTestSuiteObservers: [TestLifecycleTestSuiteObserver]
    
    public init(testLifecycleTestSuiteObservers: [TestLifecycleTestSuiteObserver] = []) {
        self.testLifecycleTestSuiteObservers = testLifecycleTestSuiteObservers
    }
    
    public func onStart(testSuite: XCTestSuite) {
        testLifecycleTestSuiteObservers.forEach {
            $0.onStart(testSuite: testSuite)
        }
    }
    
    public func onStop(testSuite: XCTestSuite) {
        testLifecycleTestSuiteObservers.forEach {
            $0.onStop(testSuite: testSuite)
        }
    }
    
    public func onFail(testSuite: XCTestSuite, description: String, filePath: String?, lineNumber: Int) {
        testLifecycleTestSuiteObservers.forEach {
            $0.onFail(
                testSuite: testSuite,
                description: description,
                filePath: filePath,
                lineNumber: lineNumber
            )
        }
    }
}
