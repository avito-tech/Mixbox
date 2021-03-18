import Bash

public final class CocoapodsRepoPushImpl: CocoapodsRepoPush {
    private let cocoapodsCommandExecutor: CocoapodsCommandExecutor
    
    public init(
        cocoapodsCommandExecutor: CocoapodsCommandExecutor)
    {
        self.cocoapodsCommandExecutor = cocoapodsCommandExecutor
    }
    
    public func push(
        repoName: String,
        pathToPodspec: String,
        verbose: Bool,
        localOnly: Bool,
        allowWarnings: Bool,
        skipImportValidation: Bool,
        skipTests: Bool,
        useJson: Bool,
        sources: [String]?)
        throws
    {
        var arguments: [String] = [
            "repo",
            "push",
            repoName,
            pathToPodspec
        ]
        
        if verbose {
            arguments.append("--verbose")
        }
        
        if localOnly {
            arguments.append("--local-only")
        }
        
        if allowWarnings {
            arguments.append("--allow-warnings")
        }
        
        if skipImportValidation {
            arguments.append("--skip-import-validation")
        }
        
        if skipTests {
            arguments.append("--skip-tests")
        }
        
        if useJson {
            arguments.append("--use-json")
        }
        
        if let sources = sources {
            arguments.append("--sources=\(sources.joined(separator: ","))")
        }
        
        _ = try cocoapodsCommandExecutor.execute(
            arguments: arguments
        )
    }
}
