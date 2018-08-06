import MixboxFoundation

public protocol TestFailureRecorder {
    func recordFailure(
        description: String,
        fileLine: FileLine,
        shouldContinueTest: Bool
    )
}
