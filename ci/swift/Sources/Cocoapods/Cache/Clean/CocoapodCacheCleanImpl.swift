public final class CocoapodCacheCleanImpl: CocoapodCacheClean {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
    }
    
    public func clean(
        target: CocoapodCacheCleanTarget)
        throws
    {
        var arguments: [String] = [
            "cache",
            "clean"
        ]
        
        switch target {
        case .podName(let name):
            arguments.append(name)
        case .all:
            arguments.append("--all")
        }
        
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments
        )
    }
}
