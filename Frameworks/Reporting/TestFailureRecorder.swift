import MixboxFoundation

public protocol TestFailureRecorder {
    func recordFailure(
        description: String,
        fileLine: FileLine?,
        shouldContinueTest: Bool
    )
}

extension TestFailureRecorder {
    public func recordFailure(
        description: String,
        shouldContinueTest: Bool)
    {
        recordFailure(
            description: description,
            fileLine: nil,
            shouldContinueTest: shouldContinueTest
        )
    }
}
