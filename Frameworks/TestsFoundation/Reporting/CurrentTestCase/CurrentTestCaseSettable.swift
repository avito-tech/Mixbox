import XCTest

public protocol CurrentTestCaseSettable {
    func setCurrentTestCase(_ testCase: XCTestCase?)
}
