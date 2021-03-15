public final class CocoapodsTrunkPushImpl: CocoapodsTrunkPush {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.cocoapodsTrunkTokenProvider = cocoapodsTrunkTokenProvider
    }
    
    public func push(
        pathToPodspec: String,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool)
        throws
    {
        var arguments: [String] = [
            "trunk",
            "push",
            pathToPodspec
        ]
        
        if allowWarnings {
            arguments.append("--allow-warnings")
        }
        
        if skipImportValidation {
            arguments.append("--skip-import-validation")
        }
        
        if skipTests {
            arguments.append("--skip-tests")
        }
        
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments,
            environment: [
                "COCOAPODS_TRUNK_TOKEN": cocoapodsTrunkTokenProvider.cocoapodsTrunkToken()
            ]
        )
    }
}
