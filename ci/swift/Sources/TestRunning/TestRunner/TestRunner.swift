import BuildArtifacts
import Destinations

public protocol TestRunner {
    func runTests(
        iosBuildArtifacts: IosBuildArtifacts,
        mixboxTestDestinationConfigurations: [MixboxTestDestinationConfiguration],
        additionalEnvironment: [String: String]
    ) throws
}
