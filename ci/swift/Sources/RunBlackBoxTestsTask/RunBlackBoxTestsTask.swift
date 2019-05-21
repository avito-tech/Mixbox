import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell

public final class RunBlackBoxTestsTask: LocalTask {
    public let name = "RunBlackBoxTestsTask"
    
    private let bashExecutor: BashExecutor
    
    public init(
        bashExecutor: BashExecutor)
    {
        self.bashExecutor = bashExecutor
    }
    
    public func execute() throws {
        try Prepare.prepareForIosTesting()
        try Emcee.installEmceeWithDependencies()
        
        try BuildUtils.buildIos(
            folder: "Tests",
            action: "build-for-testing",
            scheme: "BlackBoxUiTests",
            workspace: "Tests",
            xcodeDestination: try DestinationUtils.xcodeDestination(),
            xcodebuildPipeFilter: "xcpretty"
        )
        
        try Emcee.testUsingEmcee(
            appName: "TestedApp.app",
            testsTarget: "BlackBoxUiTests",
            additionalApp: "FakeSettingsApp.app"
        )
        try Emcee.generateReports()
        try Cleanup.cleanUpAfterIosTesting()
    }
}
