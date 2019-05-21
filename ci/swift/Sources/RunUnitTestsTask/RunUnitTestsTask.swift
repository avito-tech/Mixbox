import Bash
import Foundation
import CiFoundation
import Tasks
import Cocoapods
import Git
import SingletonHell

public final class RunUnitTestsTask: LocalTask {
    public let name = "RunUnitTestsTask"
    
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func execute() throws {
        try Prepare.prepareForIosTesting()
        
        let reportsPath = try Env.MIXBOX_CI_REPORTS_PATH.getOrThrow()
        
        let xcodebuildPipeFilter =
        """
        xcpretty -r junit -o "\(reportsPath)/junit.xml"
        """
        
        try BuildUtils.buildIos(
            folder: "Tests",
            action: "test",
            scheme: "UnitTests",
            workspace: "Tests",
            xcodeDestination: try DestinationUtils.xcodeDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
        
        try Cleanup.cleanUpAfterIosTesting()
    }
}
