import XCTest

public protocol CurrentTestCaseProvider: class {
    func currentTestCase() -> XCTestCase?
}
