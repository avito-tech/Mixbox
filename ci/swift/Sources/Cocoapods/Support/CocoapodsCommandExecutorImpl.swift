import Bundler
import Bash
import CiFoundation

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
        let result = try bundledProcessExecutor.execute(
            arguments: ["pod"] + arguments,
            currentDirectory: currentDirectory,
            environment: environment
        )
        
        if result.code != 0 {
            let argumentsJoined = arguments.joined(separator: " ")
            
            throw ErrorString(
                """
                pod \(argumentsJoined) failed with exit code \(result.code), \
                stderr: \(result.stderr.trimmedUtf8String() ?? "")
                """
            )
        }
        
        return result
    }
}
