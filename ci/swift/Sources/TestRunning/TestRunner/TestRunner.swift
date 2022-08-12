import BuildArtifacts
import Destinations

public protocol TestRunner {
    func runTests(
        iosBuildArtifacts: AppleBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        additionalEnvironment: [String: String]
    ) throws
}
