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
    private let bundlerBashCommandGenerator: BundlerBashCommandGenerator
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    
    public init(
        bashExecutor: BashExecutor,
        iosProjectBuilder: IosProjectBuilder,
        mixboxTestDestinationProvider: MixboxTestDestinationProvider,
        environmentProvider: EnvironmentProvider,
        bundlerBashCommandGenerator: BundlerBashCommandGenerator,
        bashEscapedCommandMaker: BashEscapedCommandMaker)
    {
        self.bashExecutor = bashExecutor
        self.iosProjectBuilder = iosProjectBuilder
        self.mixboxTestDestinationProvider = mixboxTestDestinationProvider
        self.environmentProvider = environmentProvider
        self.bundlerBashCommandGenerator = bundlerBashCommandGenerator
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
    }
    
    public func execute() throws {
        let reportsPath = try environmentProvider.getOrThrow(env: Env.MIXBOX_CI_REPORTS_PATH)
        
        let xcodebuildPipeFilter = bashEscapedCommandMaker.escapedCommand(
            arguments: [
                "bash",
                "-c",
                try bundlerBashCommandGenerator.bashCommandRunningCommandBundler(
                    arguments: ["xcpretty", "-r", "junit", "-o", "\(reportsPath)/junit.xml"]
                )
            ]
        )
        
        _ = try iosProjectBuilder.buildPreparationAndCleanup(
            projectDirectoryFromRepoRoot: "Tests",
            action: .test,
            scheme: "UnitTests",
            workspaceName: "Tests",
            destination: try mixboxTestDestinationProvider.mixboxTestDestination(),
            xcodebuildPipeFilter: xcodebuildPipeFilter
        )
    }
}
