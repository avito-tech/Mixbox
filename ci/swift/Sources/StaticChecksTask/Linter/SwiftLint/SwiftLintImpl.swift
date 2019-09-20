import Bash
import Git
import Cocoapods
import SingletonHell
import Foundation
import CiFoundation

public final class SwiftLintImpl: SwiftLint {
    private let processExecutor: ProcessExecutor
    private let repoRootProvider: RepoRootProvider
    private let swiftLintViolationsParser: SwiftLintViolationsParser
    
    public init(
        processExecutor: ProcessExecutor,
        repoRootProvider: RepoRootProvider,
        swiftLintViolationsParser: SwiftLintViolationsParser)
    {
        self.processExecutor = processExecutor
        self.repoRootProvider = repoRootProvider
        self.swiftLintViolationsParser = swiftLintViolationsParser
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
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
        
        if let stdout = result.stdout.utf8String() {
            let violations = try swiftLintViolationsParser.parseViolations(stdout: stdout)
            
            if violations.isEmpty {
                if result.code != 0 {
                    throw ErrorString(
                        """
                        Linting failed with exit code \(result.code), but found 0 violations
                        """
                    )
                } else {
                    // ok
                }
            } else {
                print("Found SwiftLint violations:")
                
                for violation in violations {
                    print(
                        """
                        \(violation.file):\(violation.line):\(violation.column): \
                        \(violation.type): \(violation.description) (\(violation.rule))
                        """
                    )
                }
            }
            
        } else if result.code != 0 {
            throw ErrorString(
                """
                Linting failed with exit code \(result.code), failed to parse stderr
                """
            )
        }
    }
}
