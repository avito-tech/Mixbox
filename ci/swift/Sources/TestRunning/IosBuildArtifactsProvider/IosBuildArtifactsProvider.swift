import Xcodebuild
import BuildArtifacts

public protocol IosBuildArtifactsProvider {
    func iosLogicTests(
        testsTarget: String
    ) throws -> IosBuildArtifacts
    
    func iosApplicationTests(
        appName: String,
        testsTarget: String
    ) throws -> IosBuildArtifacts
    
    func iosUiTests(
        appName: String,
        testsTarget: String,
        additionalApps: [String]
    ) throws -> IosBuildArtifacts
}
