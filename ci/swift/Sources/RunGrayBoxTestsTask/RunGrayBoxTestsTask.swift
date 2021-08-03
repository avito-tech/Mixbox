import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations
import Xcodebuild
import Bundler

public final class RunGrayBoxTestsTask: LocalTask {
    public let name = "RunGrayBoxTestsTask"
    
    private let bashExecutor: BashExecutor
    private let grayBoxTestRunner: GrayBoxTestRunner
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    private let iosProjectBuilder: IosProjectBuilder
    private let bundlerBashCommandGenerator: BundlerBashCommandGenerator
    private let bashEscapedCommandMaker: BashEscapedCommandMaker
    
    public init(
        bashExecutor: BashExecutor,
        grayBoxTestRunner: GrayBoxTestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider,
        iosProjectBuilder: IosProjectBuilder,
        bundlerBashCommandGenerator: BundlerBashCommandGenerator,
        bashEscapedCommandMaker: BashEscapedCommandMaker)
    {
        self.bashExecutor = bashExecutor
        self.grayBoxTestRunner = grayBoxTestRunner
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
        self.iosProjectBuilder = iosProjectBuilder
        self.bundlerBashCommandGenerator = bundlerBashCommandGenerator
        self.bashEscapedCommandMaker = bashEscapedCommandMaker
    }
    
    public func execute() throws {
        let mixboxTestDestinationConfigurations = try mixboxTestDestinationConfigurationsProvider
            .mixboxTestDestinationConfigurations()
        
        guard let destinationForBuilding = mixboxTestDestinationConfigurations.first?.testDestination else {
            throw ErrorString("Expected to have at least one destination for building")
        }
        
        let testsTargetAndSchemeName = "GrayBoxUiTests"
        
        let xcodebuildResult = try iosProjectBuilder.buildPreparationAndCleanup(
            projectDirectoryFromRepoRoot: "Tests",
            action: .buildForTesting,
            scheme: testsTargetAndSchemeName,
            workspaceName: "Tests",
            destination: destinationForBuilding,
            xcodebuildPipeFilter: bashEscapedCommandMaker.escapedCommand(
                arguments: [
                    "bash",
                    "-c",
                    try bundlerBashCommandGenerator
                        .bashCommandRunningCommandBundler(
                            arguments: ["xcpretty"]
                        )
                ]
            )
        )
        
        let appName = "TestedApp.app"
        
        try grayBoxTestRunner.runTests(
            xctestBundle: try xcodebuildResult.unitTestXctestBundlePath(
                appName: appName,
                testsTarget: testsTargetAndSchemeName
            ),
            appPath: try xcodebuildResult.testedAppPath(
                appName: appName
            ),
            mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations
        )
    }
}
