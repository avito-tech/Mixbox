import Bash

public final class GitRevListProviderImpl: GitRevListProvider {
    private let processExecutor: ProcessExecutor
    
    public init(
        processExecutor: ProcessExecutor)
    {
        self.processExecutor = processExecutor
    }
    
    public func revList(
        repoRoot: String,
        branch: String)
        throws
        -> [String]
    {
        let result = try processExecutor.execute(
            arguments: [
                "/usr/bin/git",
                "rev-list",
                branch
            ],
            currentDirectory: repoRoot,
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        let output = try result.stdout.trimmedUtf8String().unwrapOrThrow()
        
        return output.components(separatedBy: "\n")
    }
}
