import XCTest

public final class MutableClosuresTestLifecycleTestSuiteObserver: TestLifecycleTestSuiteObserver {
    public var onStart: ((_ testSuite: XCTestSuite) -> ())?
    public var onStop: ((_ testSuite: XCTestSuite) -> ())?
    public var onFail: ((_ testSuite: XCTestSuite, _ description: String, _ file: String?, _ line: Int) -> ())?
    
    public init(
        onStart: ((_: XCTestSuite) -> Void)? = nil,
        onStop: ((_: XCTestSuite) -> Void)? = nil,
        onFail: ((_: XCTestSuite, _: String, _: String?, _: Int) -> Void)? = nil
    ) {
        self.onStart = onStart
        self.onStop = onStop
        self.onFail = onFail
    }
    
    public func onStart(testSuite: XCTestSuite) {
        onStart?(testSuite)
    }
    
    public func onStop(testSuite: XCTestSuite) {
        onStop?(testSuite)
    }
    
    public func onFail(testSuite: XCTestSuite, description: String, filePath: String?, lineNumber: Int) {
        onFail?(testSuite, description, filePath, lineNumber)
    }
}
