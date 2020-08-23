import Bundler
import Bash

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
        environment: [String: String]?)
        throws
        -> ProcessResult
    {
        return try bundledProcessExecutor.execute(
            arguments: ["pod"] + arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
    }
}
