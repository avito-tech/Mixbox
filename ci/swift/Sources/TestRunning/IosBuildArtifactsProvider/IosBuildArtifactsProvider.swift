import Xcodebuild
import BuildArtifacts

public protocol IosBuildArtifactsProvider {
    func iosLogicTests(
        testsTarget: String
    ) throws -> AppleBuildArtifacts
    
    func iosApplicationTests(
        appName: String,
        testsTarget: String
    ) throws -> AppleBuildArtifacts
    
    func iosUiTests(
        appName: String,
        testsTarget: String,
        additionalApps: [String]
    ) throws -> AppleBuildArtifacts
}
