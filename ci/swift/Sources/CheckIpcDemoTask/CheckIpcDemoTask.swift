import Bash
import Tasks
import SingletonHell
import Xcodebuild

public final class CheckIpcDemoTask: LocalTask {
    public let name = "CheckIpcDemoTask"
    
    private let bashExecutor: BashExecutor
    private let macosProjectBuilder: MacosProjectBuilder
    
    public init(
        bashExecutor: BashExecutor,
        macosProjectBuilder: MacosProjectBuilder)
    {
        self.bashExecutor = bashExecutor
        self.macosProjectBuilder = macosProjectBuilder
    }
    
    public func execute() throws {
        _ = try macosProjectBuilder.build(
            projectDirectoryFromRepoRoot: "Demos/OsxIpcDemo",
            action: .build,
            scheme: "IpcDemo",
            workspaceName: "IpcDemo"
        )
    }
}
