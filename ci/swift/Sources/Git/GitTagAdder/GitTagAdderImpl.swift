public final class GitTagAdderImpl: GitTagAdder {
    private let gitCommandExecutor: GitCommandExecutor
    
    public init(
        gitCommandExecutor: GitCommandExecutor)
    {
        self.gitCommandExecutor = gitCommandExecutor
    }
    
    public func addTag(
        tagName: String,
        commitHash: String)
        throws
    {
        _ = try gitCommandExecutor.execute(
            arguments: [
                "tag",
                "-a", tagName,
                commitHash
            ]
        )
    }
    
    public func pushTag(
        tagName: String,
        remote: String)
        throws
    {
        _ = try gitCommandExecutor.execute(
            arguments: [
                "push",
                remote,
                tagName
            ]
        )
    }
}
