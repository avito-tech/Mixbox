import Xcodebuild
import BuildArtifacts
import Destinations

public protocol TestsTaskRunner {
    func runTests(
        build: (IosProjectBuilder, MixboxTestDestination) throws -> XcodebuildResult,
        artifacts: (IosBuildArtifactsProvider) throws -> AppleBuildArtifacts,
        additionalEnvironment: [String: String]
    ) throws
}
