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
    private let cocoapodsFactory: CocoapodsFactory
    
    private struct SetUpSwiftLint {
        let swiftlintScriptPath: String
        let sourcesToLintPath: String
    }
    
    public init(
        processExecutor: ProcessExecutor,
        repoRootProvider: RepoRootProvider,
        swiftLintViolationsParser: SwiftLintViolationsParser,
        cocoapodsFactory: CocoapodsFactory)
    {
        self.processExecutor = processExecutor
        self.repoRootProvider = repoRootProvider
        self.swiftLintViolationsParser = swiftLintViolationsParser
        self.cocoapodsFactory = cocoapodsFactory
    }
    
    public func lint() throws {
        let setUpSwiftLint = try self.setUpSwiftLint()
        
        let swiftlintResult = try executeSwiftLint(
            setUpSwiftLint: setUpSwiftLint
        )
        
        try handle(swiftlintResult: swiftlintResult)
    }
    
    private func setUpSwiftLint() throws -> SetUpSwiftLint {
        let repoRootPath = try repoRootProvider.repoRootPath()
        
        let testsProjectDirectory = "\(repoRootPath)/Tests"
        
        let cocoapods = try cocoapodsFactory.cocoapods(projectDirectory: testsProjectDirectory)
        
        try cocoapods.install()
        
        return SetUpSwiftLint(
            swiftlintScriptPath: "\(testsProjectDirectory)/Pods/SwiftLint/swiftlint",
            sourcesToLintPath: repoRootPath
        )
    }
    
    private func executeSwiftLint(
        setUpSwiftLint: SetUpSwiftLint)
        throws
        -> ProcessResult
    {
        return try processExecutor.execute(
            executable: setUpSwiftLint.swiftlintScriptPath,
            arguments: [],
            currentDirectory: setUpSwiftLint.sourcesToLintPath,
            environment: [:],
            stdoutDataHandler: { _ in },
            stderrDataHandler: { _ in }
        )
    }
    
    private func handle(swiftlintResult: ProcessResult) throws {
        if let stdout = swiftlintResult.stdout.utf8String() {
            let violations = try swiftLintViolationsParser.parseViolations(stdout: stdout)
            
            if violations.isEmpty {
                if swiftlintResult.code != 0 {
                    throw ErrorString(
                        """
                        Linting failed with exit code \(swiftlintResult.code), but found 0 violations
                        """
                    )
                } else {
                    // SwiftLint checks have passed successfully
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
                
                throw ErrorString(
                    """
                    Linting failed with \(violations.count) violations
                    """
                )
            }
        } else if swiftlintResult.code != 0 {
            throw ErrorString(
                """
                Linting failed with exit code \(swiftlintResult.code), failed to parse stderr
                """
            )
        }
    }
}
