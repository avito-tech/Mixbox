import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations
import Xcodebuild
import Bundler

public final class RunBlackBoxTestsTask: LocalTask {
    public let name = "RunBlackBoxTestsTask"
    
    private let bashExecutor: BashExecutor
    private let blackBoxTestRunner: BlackBoxTestRunner
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    private let iosProjectBuilder: IosProjectBuilder
    private let bundlerCommandGenerator: BundlerCommandGenerator
    
    public init(
        bashExecutor: BashExecutor,
        blackBoxTestRunner: BlackBoxTestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider,
        iosProjectBuilder: IosProjectBuilder,
        bundlerCommandGenerator: BundlerCommandGenerator)
    {
        self.bashExecutor = bashExecutor
        self.blackBoxTestRunner = blackBoxTestRunner
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
        
        let xcodebuildResult = try iosProjectBuilder.build(
            projectDirectoryFromRepoRoot: "Tests",
            action: .buildForTesting,
            scheme: "BlackBoxUiTests",
            workspaceName: "Tests",
            testDestination: destinationForBuilding,
            xcodebuildPipeFilter: try bundlerCommandGenerator.bundlerCommand(command: "xcpretty")
        )
        
        try test(
            appName: "TestedApp.app",
            testsTarget: "BlackBoxUiTests",
            additionalApp: "FakeSettingsApp.app",
            xcodebuildResult: xcodebuildResult,
            mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations
        )
    }
    
    private func test(
        appName: String,
        testsTarget: String,
        additionalApp: String,
        xcodebuildResult: XcodebuildResult,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration])
        throws
    {
        try blackBoxTestRunner.runTests(
            xctestBundle: xcodebuildResult.uiTestXctestBundlePath(testsTarget: testsTarget),
            runnerPath: xcodebuildResult.uiTestRunnerAppPath(testsTarget: testsTarget),
            appPath: xcodebuildResult.testedAppPath(appName: appName),
            additionalAppPaths: [xcodebuildResult.testedAppPath(appName: additionalApp)],
            mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations
        )
    }
}
