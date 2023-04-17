import Destinations
import BuildArtifactsApple

public protocol TestRunner {
    func runTests(
        iosBuildArtifacts: AppleBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        additionalEnvironment: [String: String]
    ) throws
}
