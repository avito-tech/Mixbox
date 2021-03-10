import Bash

public final class GitRevListProviderImpl: GitRevListProvider {
    private let gitCommandExecutor: GitCommandExecutor
    
    public init(
        gitCommandExecutor: GitCommandExecutor)
    {
        self.gitCommandExecutor = gitCommandExecutor
    }
    
    public func revList(
        branch: String)
        throws
        -> [String]
    {
        let output = try gitCommandExecutor.execute(
            arguments: [
                "rev-list",
                branch
            ]
        )
        
        return output.components(separatedBy: "\n")
    }
}
