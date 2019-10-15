import Bash
import Foundation
import CiFoundation
import Tasks
import Cocoapods
import Git
import SingletonHell
import Destinations
import Xcodebuild
import Bundler

public final class RunUnitTestsTask: LocalTask {
    public let name = "RunUnitTestsTask"
    
    private let bashExecutor: BashExecutor
    private let iosProjectBuilder: IosProjectBuilder
    private let mixboxTestDestinationProvider: MixboxTestDestinationProvider
    private let environmentProvider: EnvironmentProvider
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        iosProjectBuilder: IosProjectBuilder,
        mixboxTestDestinationProvider: MixboxTestDestinationProvider,
        environmentProvider: EnvironmentProvider,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.iosProjectBuilder = iosProjectBuilder
        self.mixboxTestDestinationProvider = mixboxTestDestinationProvider
        self.environmentProvider = environmentProvider
        self.bundlerCommandGenerator = bundlerCommandGenerator
    }
    
    public func execute() throws {
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        
        let xcodebuildPipeFilter = try bundlerCommandGenerator.bundlerCommand(
            command:
            """
            xcpretty -r junit -o "\(reportsPath)/junit.xml"
            """
        )
        
        try iosProjectBuilder.test(
            projectDirectoryFromRepoRoot: "Tests",
            scheme: "UnitTests",
            workspaceName: "Tests",
            testDestination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
    }
}
