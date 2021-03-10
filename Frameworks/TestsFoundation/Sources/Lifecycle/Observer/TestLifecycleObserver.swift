import XCTest

public final class TestLifecycleObserver {
    public final class TestBundleObserver {
        public var onStart: ((_ bundle: Bundle) -> ())?
        public var onStop: ((_ bundle: Bundle) -> ())?
    }
    public final class TestSuiteObserver {
        public var onStart: ((_ testSuite: XCTestSuite) -> ())?
        public var onStop: ((_ testSuite: XCTestSuite) -> ())?
        public var onFail: ((_ testSuite: XCTestSuite, _ description: String, _ file: String?, _ line: Int) -> ())?
    }
    public final class TestCaseObserver {
        public var onStart: ((_ testCase: XCTestCase) -> ())?
        public var onStop: ((_ testCase: XCTestCase) -> ())?
        public var onFail: ((_ testSuite: XCTestCase, _ description: String, _ file: String?, _ line: Int) -> ())?
    }
    
    public var testBundleObserver = TestBundleObserver()
    public var testSuiteObserver = TestSuiteObserver()
    public var testCaseObserver = TestCaseObserver()
    
    public init() {
    }
}
