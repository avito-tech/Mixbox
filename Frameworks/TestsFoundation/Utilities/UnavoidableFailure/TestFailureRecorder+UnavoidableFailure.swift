import MixboxFoundation

extension TestFailureRecorder {
    public func recordUnavoidableFailure(
        description: String,
        fileLine: FileLine? = nil)
        -> Never
    {
        recordFailure(
            description: description,
            fileLine: fileLine,
            shouldContinueTest: false
        )
        UnavoidableFailure.fail(description)
    }
}
