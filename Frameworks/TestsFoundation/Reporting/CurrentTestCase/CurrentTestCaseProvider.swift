import XCTest

public protocol CurrentTestCaseProvider {
    func currentTestCase() -> XCTestCase?
}
