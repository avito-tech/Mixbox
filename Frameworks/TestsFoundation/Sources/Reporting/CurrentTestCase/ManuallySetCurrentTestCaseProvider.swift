import XCTest

public final class ManuallySetCurrentTestCaseProvider: CurrentTestCaseProvider, CurrentTestCaseSettable {
    private weak var testCase: XCTestCase?
    
    public init() {
    }
    
    public func currentTestCase() -> XCTestCase? {
        return testCase
    }
    
    public func setCurrentTestCase(_ testCase: XCTestCase?) {
        self.testCase = testCase
    }
}
