protocol CurrentTestCaseProvider {
    func currentTestCase() -> TestCase?
}

protocol CurrentTestCaseSettable {
    func setCurrentTestCase(_ testCase: TestCase?)
}

final class CurrentTestCaseProviderImpl: CurrentTestCaseProvider, CurrentTestCaseSettable {
    private var testCase: TestCase?
    
    func currentTestCase() -> TestCase? {
        return testCase
    }
    
    func setCurrentTestCase(_ testCase: TestCase?) {
        self.testCase = testCase
    }
}
