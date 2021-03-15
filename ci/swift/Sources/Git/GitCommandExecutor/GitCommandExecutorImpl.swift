import Bash
import CiFoundation

public final class GitCommandExecutorImpl: GitCommandExecutor {
    private let processExecutor: ProcessExecutor
    private let repoRootProvider: RepoRootProvider
    
    public init(
        processExecutor: ProcessExecutor,
        repoRootProvider: RepoRootProvider)
    {
        self.processExecutor = processExecutor
        self.repoRootProvider = repoRootProvider
    }
    
    public func execute(
        arguments: [String])
        throws
        -> String
    {
        let arguments = ["/usr/bin/git"] + arguments
        
        let result = try processExecutor.execute(
            arguments: arguments,
            currentDirectory: try repoRootProvider.repoRootPath(),
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        if result.code != 0 {
            let argumentsAsString = arguments.joined(separator: " ")
            throw ErrorString(
                """
                Failed to execute "\(argumentsAsString)" with exit code \(result.code)
                Stderr:
                \(result.stderr.utf8String() ?? "")
                Stdout:
                \(result.stdout.utf8String() ?? "")
                """
            )
        }
        
        return try result.stdout.trimmedUtf8String().unwrapOrThrow()
    }
}
