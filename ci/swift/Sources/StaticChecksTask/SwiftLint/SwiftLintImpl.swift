import Bash
import Git
import Cocoapods
import SingletonHell
import Foundation
import CiFoundation

public final class SwiftLintImpl: SwiftLint {
    private let processExecutor: ProcessExecutor
    private let repoRootProvider: RepoRootProvider
    
    public init(
        processExecutor: ProcessExecutor,
        repoRootProvider: RepoRootProvider)
    {
        self.processExecutor = processExecutor
        self.repoRootProvider = repoRootProvider
    }
    
    public func lint() throws {
        let repoRootPath = try repoRootProvider.repoRootPath()
        
        let testsProjectDirectory = "\(repoRootPath)/Tests"
        
        try bash(
            command: "pod install || pod install --repo-update",
            currentDirectory: testsProjectDirectory
        )
        
        let swiftlintScriptPath = "\(testsProjectDirectory)/Pods/SwiftLint/swiftlint"
        
        let result = try processExecutor.execute(
            executable: swiftlintScriptPath,
            arguments: [],
            currentDirectory: repoRootPath,
            environment: [:],
            stdoutDataHandler: { data in
                FileHandle.standardOutput.write(data)
            },
            stderrDataHandler: { data in
                FileHandle.standardError.write(data)
            }
        )
        
        if result.code != 0 {
            throw ErrorString(
                """
                Linting failed with exit code \(result.code)"
                """
            )
        }
    }
}
