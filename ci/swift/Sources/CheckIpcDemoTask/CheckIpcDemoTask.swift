import Bash
import Tasks
import SingletonHell

public final class CheckIpcDemoTask: LocalTask {
    public let name = "CheckIpcDemoTask"
    
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func execute() throws {
        try Prepare.prepareForMacOsTesting()
        
        try BuildUtils.buildMacOs(
            folder: "Frameworks/BuiltinIpc/OsxDemo",
            action: "build",
            scheme: "IpcDemo",
            workspace: "IpcDemo"
        )
        
        try Cleanup.cleanUpAfterMacOsTesting()
    }
}
