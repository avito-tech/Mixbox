import Bash
import Tasks
import SingletonHell

public final class CheckDemoTask: LocalTask {
    public let name = "CheckDemoTask"
    
    private let bashExecutor: BashExecutor
    private let cocoapodsVersion: String?
    
    public init(
        bashExecutor: BashExecutor,
        // WARNING: Do not set cocoapods version for teamcity builds!
        // Our CI doesn't support vistualization and we have only 1 version of cocoapods.
        cocoapodsVersion: String?)
    {
        self.bashExecutor = bashExecutor
        self.cocoapodsVersion = cocoapodsVersion
    }
    
    public func execute() throws {
        if let cocoapodsVersion = cocoapodsVersion {
            try bash(
                """
                (which pod && [ `pod --version` == "\(cocoapodsVersion)" ]) \
                || gem install cocoapods -v "\(cocoapodsVersion)"
                """
            )
        }
        
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
