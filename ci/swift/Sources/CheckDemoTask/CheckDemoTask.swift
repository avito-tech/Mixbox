import Bash
import Tasks
import SingletonHell

public final class CheckDemoTask: LocalTask {
    public let name = "CheckDemoTask"
    
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func execute() throws {
        try Prepare.prepareForIosTesting(rebootSimulator: true)
        
        let reportsPath = try Env.MIXBOX_CI_REPORTS_PATH.getOrThrow()
        
        let xcodebuildPipeFilter =
        """
        xcpretty -r junit -o "\(reportsPath)/junit.xml"
        """
        
        try BuildUtils.buildIos(
            folder: "Demos/OversimplifiedDemo",
            action: "test",
            scheme: "OversimplifiedDemo",
            workspace: "OversimplifiedDemo",
            xcodeDestination: try DestinationUtils.xcodeDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
        
        try Cleanup.cleanUpAfterIosTesting()
    }
}
