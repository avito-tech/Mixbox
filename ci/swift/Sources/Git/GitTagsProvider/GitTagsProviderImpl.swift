import Bash
import CiFoundation

public final class GitTagsProviderImpl: GitTagsProvider {
    private let processExecutor: ProcessExecutor
    
    public init(
        processExecutor: ProcessExecutor)
    {
        self.processExecutor = processExecutor
    }
    
    public func gitTags(repoRoot: String) throws -> [GitTag] {
        let separator = ";"
        
        let result = try processExecutor.execute(
            arguments: [
                "/usr/bin/git",
                "tag",
                "--list",
                "--format", "%(objectname)\(separator)%(refname:strip=2)"
            ],
            currentDirectory: repoRoot,
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        let output = try result.stdout.trimmedUtf8String().unwrapOrThrow()
        
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
