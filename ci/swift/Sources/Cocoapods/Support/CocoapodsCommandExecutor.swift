import Bash

public protocol CocoapodsCommandExecutor {
    func executeImpl(
        // Example: ["pod", "install"]
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String]?)
        throws
        -> ProcessResult
}

extension CocoapodsCommandExecutor {
    public func execute(
        arguments: [String],
        currentDirectory: String? = nil,
        environment: [String: String]? = nil)
        throws
        -> ProcessResult
    {
        return try executeImpl(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
    }
}
