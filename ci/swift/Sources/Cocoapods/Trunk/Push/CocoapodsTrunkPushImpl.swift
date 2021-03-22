import CiFoundation

public final class CocoapodsTrunkPushImpl: CocoapodsTrunkPush {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    private let cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider
    private let environmentProvider: EnvironmentProvider
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor,
        cocoapodsTrunkTokenProvider: CocoapodsTrunkTokenProvider,
        environmentProvider: EnvironmentProvider)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
        self.cocoapodsTrunkTokenProvider = cocoapodsTrunkTokenProvider
        self.environmentProvider = environmentProvider
    }
    
    public func push(
        pathToPodspec: String,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool,
        synchronous: Bool)
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
        
        if synchronous {
            arguments.append("--synchronous")
        }
        
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments,
            environment: [
                "COCOAPODS_TRUNK_TOKEN": cocoapodsTrunkTokenProvider.cocoapodsTrunkToken()
            ].merging(environmentProvider.environment, uniquingKeysWith: { left, _ in left })
        )
    }
}
