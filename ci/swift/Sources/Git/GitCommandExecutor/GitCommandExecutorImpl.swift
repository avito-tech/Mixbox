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
        let result = try processExecutor.execute(
            arguments: ["/usr/bin/git"] + arguments,
            currentDirectory: try repoRootProvider.repoRootPath(),
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        if result.code != 0 {
            throw ErrorString(
                """
                Failed to execute "git \(arguments.joined(separator: " "))" with exit code \(result.code)"
                """
            )
        }
        
        return try result.stdout.trimmedUtf8String().unwrapOrThrow()
    }
}
