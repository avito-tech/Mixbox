import XCTest

public protocol CurrentTestCaseSettable: class {
    func setCurrentTestCase(_ testCase: XCTestCase?)
}
