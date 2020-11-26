import MixboxFoundation

extension TestFailureRecorder {
    public func recordUnavoidableFailure(
        description: String,
        file: StaticString = #file,
        line: UInt = #line)
        -> Never
    {
        recordUnavoidableFailure(
            description: description,
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
    
    public func recordUnavoidableFailure(
        description: String,
        fileLine: FileLine)
        -> Never
    {
        recordFailure(
            description: description,
            fileLine: fileLine,
            shouldContinueTest: false
        )
        
        UnavoidableFailure.fail(
            message: description,
            fileLine: fileLine
        )
    }
}
