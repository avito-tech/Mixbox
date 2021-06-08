import XCTest

public protocol CurrentTestCaseProvider: AnyObject {
    func currentTestCase() -> XCTestCase?
}
