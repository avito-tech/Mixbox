import XCTest

public protocol TestLifecycleTestSuiteObserver {
    func onStart(testSuite: XCTestSuite)
    func onStop(testSuite: XCTestSuite)
    func onFail(testSuite: XCTestSuite, description: String, filePath: String?, lineNumber: Int)
}
