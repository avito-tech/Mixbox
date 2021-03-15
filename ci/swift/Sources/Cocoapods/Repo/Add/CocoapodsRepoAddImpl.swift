public final class CocoapodsRepoAddImpl: CocoapodsRepoAdd {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
    }
    
    public func add(
        repoName: String,
        url: String)
        throws
    {
        let arguments: [String] = [
            "repo",
            "add",
            repoName,
            url
        ]
        
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments
        )
    }
}
