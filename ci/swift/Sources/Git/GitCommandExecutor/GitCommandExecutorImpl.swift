import Bash
import CiFoundation

public final class GitCommandExecutorImpl: GitCommandExecutor {
    private let processExecutor: ProcessExecutor
    private let repoRootProvider: RepoRootProvider
    private let environmentProvider: EnvironmentProvider
    
    public init(
        processExecutor: ProcessExecutor,
        repoRootProvider: RepoRootProvider,
        environmentProvider: EnvironmentProvider)
    {
        self.processExecutor = processExecutor
        self.repoRootProvider = repoRootProvider
        self.environmentProvider = environmentProvider
    }
    
    public func execute(
        arguments: [String])
        throws
        -> String
    {
        let arguments = ["/usr/bin/git"] + arguments
        
        let result = try processExecutor.executeOrThrow(
            arguments: arguments,
            currentDirectory: try repoRootProvider.repoRootPath(),
            environment: environmentProvider.environment,
            outputHandling: .ignore
        )
        
        return try result.stdout.trimmedUtf8String().unwrapOrThrow()
    }
}
