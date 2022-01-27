import Bundler
import Bash
import CiFoundation
import EmceeExtensions

public final class CocoapodsCommandExecutorImpl: CocoapodsCommandExecutor {
    private let bundledProcessExecutor: BundledProcessExecutor
    
    public init(
        bundledProcessExecutor: BundledProcessExecutor)
    {
        self.bundledProcessExecutor = bundledProcessExecutor
    }
    
    public func executeImpl(
        arguments: [String],
        currentDirectory: String?,
        environment: [String: String]?,
        shouldThrowOnNonzeroExitCode: Bool)
        throws
        -> ProcessResult
    {
        return try bundledProcessExecutor.execute(
            arguments: [
                "ruby",
                #file.deletingLastPathComponent.appending(pathComponent: "patched_pod.rb")
            ] + arguments,
            currentDirectory: currentDirectory,
            environment: environment,
            shouldThrowOnNonzeroExitCode: shouldThrowOnNonzeroExitCode
        )
    }
}
