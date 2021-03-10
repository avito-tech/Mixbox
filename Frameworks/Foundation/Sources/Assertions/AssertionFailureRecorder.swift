#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol AssertionFailureRecorder: class {
    func recordAssertionFailure(
        message: String,
        fileLine: FileLine)
}

extension AssertionFailureRecorder {
    public func recordAssertionFailure(
        message: String,
        file: StaticString = #file,
        line: UInt = #line)
    {
        recordAssertionFailure(
            message: message,
            fileLine: FileLine(
                file: file,
                line: line
            )
        )
    }
}

#endif
