import TestDiscovery
import Foundation
import Destinations
import RunnerModels
import BuildArtifactsApple

public final class TestArgFileGeneratorArguments {
    public let iosBuildArtifacts: AppleBuildArtifacts
    public let mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration]
    public let environment: [String: String]
    public let priority: UInt
    
    public init(
        iosBuildArtifacts: AppleBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        environment: [String: String],
        priority: UInt)
    {
        self.iosBuildArtifacts = iosBuildArtifacts
        self.mixboxTestDestinationConfigurations = mixboxTestDestinationConfigurations
        self.environment = environment
        self.priority = priority
    }
}
