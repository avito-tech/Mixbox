import Bash

public final class BashCocoapods: Cocoapods {
    private let bashExecutor: BashExecutor
    private let projectDirectory: String
    
    public init(
        bashExecutor: BashExecutor,
        projectDirectory: String)
    {
        self.bashExecutor = bashExecutor
        self.projectDirectory = projectDirectory
    }
    
    public func install() throws {
        do {
            _ = try bashExecutor.executeOrThrow(
                command: "pod install --verbose || pod install --repo-update --verbose",
                currentDirectory: projectDirectory
            )
        } catch _ {
            // Fallback
            
            _ = try bashExecutor.executeOrThrow(
                command: "rm -f ~/.cocoapods/repos/master/.git/index.lock && pod repo update && pod install --verbose",
                currentDirectory: projectDirectory
            )
        }
    }
}
