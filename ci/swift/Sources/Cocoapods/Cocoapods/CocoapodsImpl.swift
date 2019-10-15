import Bash
import Bundler

public final class CocoapodsImpl: Cocoapods {
    private let bashExecutor: BashExecutor
    private let projectDirectory: String
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        projectDirectory: String,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.projectDirectory = projectDirectory
        self.bundlerCommandGenerator = bundlerCommandGenerator
    }
    
    public func install() throws {
        do {
            _ = try bashExecutor.executeOrThrow(
                command:
                """
                   \(bundle("pod install --verbose")) \
                || \(bundle("pod install --repo-update --verbose"))
                """,
                currentDirectory: projectDirectory
            )
        } catch _ {
            // Fallback
            
            _ = try bashExecutor.executeOrThrow(
                command:
                """
                rm -f ~/.cocoapods/repos/master/.git/index.lock \
                && \(bundle("pod repo update")) \
                && \(bundle("pod install --verbose"))
                """,
                currentDirectory: projectDirectory
            )
        }
    }
    
    private func bundle(_ command: String) throws -> String {
        return try bundlerCommandGenerator.bundlerCommand(command: command)
    }
}
