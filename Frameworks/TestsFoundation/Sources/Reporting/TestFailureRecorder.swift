import MixboxFoundation

public protocol TestFailureRecorder: class {
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
    
    public func recordMixboxInternalFailure(
        description: String,
        shouldContinueTest: Bool,
        file: StaticString = #file,
        line: UInt = #line)
    {
        recordFailure(
            description: "Internal failure in Mixbox in \(file):\(line): \(description)",
            fileLine: FileLine(file: file, line: line),
            shouldContinueTest: shouldContinueTest
        )
    }
}
