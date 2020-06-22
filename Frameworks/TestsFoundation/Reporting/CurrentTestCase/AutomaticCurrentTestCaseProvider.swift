import XCTest
import MixboxTestsFoundation_objc

public final class AutomaticCurrentTestCaseProvider: CurrentTestCaseProvider {
    public init() {
    }
    
    public func currentTestCase() -> XCTestCase? {
        return _XCTCurrentTestCase() as? XCTestCase
    }
}
