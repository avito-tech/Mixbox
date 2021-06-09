import Bash
import CiFoundation

public protocol CocoapodsCommandExecutor {
    func executeImpl(
        // Example: ["pod", "install"]
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String]?,
        shouldThrowOnNonzeroExitCode: Bool)
        throws
        -> ProcessResult
}

extension CocoapodsCommandExecutor {
    public func execute(
        arguments: [String],
        currentDirectory: String? = nil,
        environment: [String: String]? = nil,
        shouldThrowOnNonzeroExitCode: Bool = true)
        throws
        -> ProcessResult
    {
        let result = try executeImpl(
            arguments: arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            shouldThrowOnNonzeroExitCode: shouldThrowOnNonzeroExitCode
        )
        
        return result
    }
}
