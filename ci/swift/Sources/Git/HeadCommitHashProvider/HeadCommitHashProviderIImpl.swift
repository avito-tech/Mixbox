import Bash

public final class HeadCommitHashProviderImpl: HeadCommitHashProvider {
    private let gitCommandExecutor: GitCommandExecutor
    
    public init(
        gitCommandExecutor: GitCommandExecutor)
    {
        self.gitCommandExecutor = gitCommandExecutor
    }
    
    public func headCommitHash()
        throws
        -> String
    {
        return try gitCommandExecutor.execute(
            arguments: [
                "rev-parse",
                "HEAD"
            ]
        )
    }
}
