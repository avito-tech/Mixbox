import Bash

public protocol CocoapodsTrunkCommandExecutor {
    func executeImpl(
        arguments: [String],
        shouldThrowOnNonzeroExitCode: Bool)
        throws
        -> ProcessResult
}

extension CocoapodsTrunkCommandExecutor {
    public func execute(
        arguments: [String],
        shouldThrowOnNonzeroExitCode: Bool = true)
        throws
        -> ProcessResult
    {
        return try executeImpl(
            arguments: arguments,
            shouldThrowOnNonzeroExitCode: shouldThrowOnNonzeroExitCode
        )
    }
}
