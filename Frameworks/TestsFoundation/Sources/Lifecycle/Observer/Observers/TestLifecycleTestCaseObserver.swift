import XCTest

public protocol TestLifecycleTestCaseObserver {
    func onStart(testCase: XCTestCase)
    func onStop(testCase: XCTestCase)
    func onFail(testCase: XCTestCase, description: String, filePath: String?, lineNumber: Int)
}
