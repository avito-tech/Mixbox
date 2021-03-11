public final class CocoapodsTrunkPushImpl: CocoapodsTrunkPush {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let cocoapodsTrunkToken: String
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        cocoapodsTrunkToken: String)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.cocoapodsTrunkToken = cocoapodsTrunkToken
    }
    
    public func push(pathToPodspec: String) throws {
        _ = try cocoapodsCommandExecutor.execute(
            arguments: ["trunk", "push", pathToPodspec],
            environment: [
                "COCOAPODS_TRUNK_TOKEN": cocoapodsTrunkToken
            ]
        )
    }
}
