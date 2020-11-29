import MixboxTestsFoundation

protocol UninterceptableErrorRecorder {
    func recordFailures(testCase: TestCaseSuppressingWarningAboutDeprecatedRecordFailure)
}
