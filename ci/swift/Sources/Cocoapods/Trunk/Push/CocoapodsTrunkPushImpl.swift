import CiFoundation

public final class CocoapodsTrunkPushImpl: CocoapodsTrunkPush {
    private let cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor
    
    public init(
        cocoapodsTrunkCommandExecutor: CocoapodsTrunkCommandExecutor)
    {
        self.cocoapodsTrunkCommandExecutor = cocoapodsTrunkCommandExecutor
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
        
        _ = try cocoapodsTrunkCommandExecutor.execute(arguments: arguments)
    }
}
