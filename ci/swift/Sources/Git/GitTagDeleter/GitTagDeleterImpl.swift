public final class GitTagDeleterImpl: GitTagDeleter {
    private let gitCommandExecutor: GitCommandExecutor
    
    public init(
        gitCommandExecutor: GitCommandExecutor)
    {
        self.gitCommandExecutor = gitCommandExecutor
    }
    
    public func deleteLocalTag(
        tagName: String)
        throws
    {
        _ = try gitCommandExecutor.execute(
            arguments: [
                "tag",
                "--delete",
                tagName
            ]
        )
    }
    
    public func deleteRemoteTag(
        tagName: String,
        remoteName: String)
        throws
    {
        _ = try gitCommandExecutor.execute(
            arguments: [
                "push",
                remoteName,
                ":refs/tags/\(tagName)"
            ]
        )
    }
}
