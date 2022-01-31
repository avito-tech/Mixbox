import Xcodebuild
import BuildArtifacts
import Destinations

public protocol TestsTaskRunner {
    func runTests(
        build: (IosProjectBuilder, MixboxTestDestination) throws -> XcodebuildResult,
        artifacts: (IosBuildArtifactsProvider) throws -> IosBuildArtifacts,
        additionalEnvironment: [String: String]
    ) throws
}
