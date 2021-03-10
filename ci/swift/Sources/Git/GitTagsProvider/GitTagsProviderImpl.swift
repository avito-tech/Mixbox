import Bash
import CiFoundation

public final class GitTagsProviderImpl: GitTagsProvider {
    private let gitCommandExecutor: GitCommandExecutor
    
    public init(
        gitCommandExecutor: GitCommandExecutor)
    {
        self.gitCommandExecutor = gitCommandExecutor
    }
    
    public func gitTags() throws -> [GitTag] {
        let separator = ";"
        
        let output = try gitCommandExecutor.execute(
            arguments: [
                "tag",
                "--list",
                "--format", "%(objectname)\(separator)%(refname:strip=2)"
            ]
        )
        
        let rawTags = output.components(separatedBy: "\n")
        
        return try rawTags.map { rawTag in
            let components = rawTag.components(separatedBy: separator)
            
            guard let sha = components.first, components.count >= 2 else {
                throw ErrorString("Expected tag in format 'sha;name', got: '\(rawTag)'")
            }
            
            let name = components.dropFirst().joined(separator: separator)
            
            return GitTag(
                name: name,
                sha: sha
            )
        }
    }
}
