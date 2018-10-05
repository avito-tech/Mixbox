import XCTest

public final class AutomaticCurrentTestCaseProvider: CurrentTestCaseProvider {
    public init() {
    }
    
    public func currentTestCase() -> XCTestCase? {
        return _XCTCurrentTestCase() as? XCTestCase
    }
}
