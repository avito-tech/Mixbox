public final class MutableClosuresTestLifecycleTestCaseObserver: TestLifecycleTestCaseObserver {
    public var onStart: ((_ testCase: XCTestCase) -> ())?
    public var onStop: ((_ testCase: XCTestCase) -> ())?
    public var onFail: ((_ testCase: XCTestCase, _ description: String, _ file: String?, _ line: Int) -> ())?
    
    public init(
        onStart: ((_: XCTestCase) -> Void)? = nil,
        onStop: ((_: XCTestCase) -> Void)? = nil,
        onFail: ((_: XCTestCase, _: String, _: String?, _: Int) -> Void)? = nil
    ) {
        self.onStart = onStart
        self.onStop = onStop
        self.onFail = onFail
    }
    
    public func onStart(testCase: XCTestCase) {
        onStart?(testCase)
    }
    
    public func onStop(testCase: XCTestCase) {
        onStop?(testCase)
    }
    
    public func onFail(testCase: XCTestCase, description: String, filePath: String?, lineNumber: Int) {
        onFail?(testCase, description, filePath, lineNumber)
    }
}
