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
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        grayBoxTestRunner: GrayBoxTestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider,
        iosProjectBuilder: IosProjectBuilder,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.grayBoxTestRunner = grayBoxTestRunner
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
        self.iosProjectBuilder = iosProjectBuilder
        self.bundlerCommandGenerator = bundlerCommandGenerator
    }
    
    public func execute() throws {
        let mixboxTestDestinationConfigurations = try mixboxTestDestinationConfigurationsProvider
            .mixboxTestDestinationConfigurations()
        
        guard let destinationForBuilding = mixboxTestDestinationConfigurations.first?.testDestination else {
            throw ErrorString("Expected to have at least one destination for building")
        }
        
        let testsTargetAndSchemeName = "GrayBoxUiTests"
        
        let xcodebuildResult = try iosProjectBuilder.build(
            projectDirectoryFromRepoRoot: "Tests",
            action: .buildForTesting,
            scheme: testsTargetAndSchemeName,
            workspaceName: "Tests",
            testDestination: destinationForBuilding,
            xcodebuildPipeFilter: try bundlerCommandGenerator.bundlerCommand(command: "xcpretty")
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
