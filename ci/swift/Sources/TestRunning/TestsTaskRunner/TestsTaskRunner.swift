import Xcodebuild
import Destinations
import BuildArtifactsApple

public protocol TestsTaskRunner {
    func runTests(
        build: (IosProjectBuilder, MixboxTestDestination) throws -> XcodebuildResult,
        artifacts: (IosBuildArtifactsProvider) throws -> AppleBuildArtifacts,
        additionalEnvironment: [String: String]
    ) throws
}
