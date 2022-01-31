import Bash
import Foundation
import CiFoundation
import Tasks
import SingletonHell
import Emcee
import Destinations
import Xcodebuild
import Bundler
import BuildArtifacts

public final class TestsTaskRunnerImpl: TestsTaskRunner {
    private let testRunner: TestRunner
    private let mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider
    private let iosProjectBuilder: IosProjectBuilder
    private let iosBuildArtifactsProviderFactory: IosBuildArtifactsProviderFactory
    
    public init(
        testRunner: TestRunner,
        mixboxTestDestinationConfigurationsProvider: MixboxTestDestinationConfigurationsProvider,
        iosProjectBuilder: IosProjectBuilder,
        iosBuildArtifactsProviderFactory: IosBuildArtifactsProviderFactory)
    {
        self.testRunner = testRunner
        self.mixboxTestDestinationConfigurationsProvider = mixboxTestDestinationConfigurationsProvider
        self.iosProjectBuilder = iosProjectBuilder
        self.iosBuildArtifactsProviderFactory = iosBuildArtifactsProviderFactory
    }
    
    public func runTests(
        build: (IosProjectBuilder, MixboxTestDestination) throws -> XcodebuildResult,
        artifacts: (IosBuildArtifactsProvider) throws -> IosBuildArtifacts,
        additionalEnvironment: [String: String]
    ) throws {
        let mixboxTestDestinationConfigurations = try mixboxTestDestinationConfigurationsProvider
            .mixboxTestDestinationConfigurations()
        
        guard let destinationForBuilding = mixboxTestDestinationConfigurations.first?.testDestination else {
            throw ErrorString("Expected to have at least one destination for building")
        }
        
        let xcodebuildResult = try build(iosProjectBuilder, destinationForBuilding)

        try testRunner.runTests(
            iosBuildArtifacts: try artifacts(
                iosBuildArtifactsProviderFactory.iosBuildArtifactsProvider(
                    xcodebuildResult: xcodebuildResult
                )
            ),
            mixboxTestDestinationConfigurations: mixboxTestDestinationConfigurations,
            additionalEnvironment: additionalEnvironment
        )
    }
}
