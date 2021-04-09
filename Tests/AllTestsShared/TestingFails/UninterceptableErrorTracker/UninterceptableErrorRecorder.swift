import MixboxTestsFoundation

protocol UninterceptableErrorRecorder {
    func recordFailures(testCase: XCTestCase)
}
