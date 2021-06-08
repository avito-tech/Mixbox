import XCTest

public protocol CurrentTestCaseSettable: AnyObject {
    func setCurrentTestCase(_ testCase: XCTestCase?)
}
