import Bash

public final class CurrentCommitProviderImpl: CurrentCommitProvider {
    private let processExecutor: ProcessExecutor
    
    public init(
        processExecutor: ProcessExecutor)
    {
        self.processExecutor = processExecutor
    }
    
    public func currentCommit(
        repoRoot: String)
        throws
        -> String
    {
        let result = try processExecutor.execute(
            arguments: [
                "/usr/bin/git",
                "rev-parse",
                "HEAD"
            ],
            currentDirectory: repoRoot,
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        return try result.stdout.trimmedUtf8String().unwrapOrThrow()
    }
}
