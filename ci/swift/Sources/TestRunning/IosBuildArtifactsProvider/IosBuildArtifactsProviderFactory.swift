import Xcodebuild

public protocol IosBuildArtifactsProviderFactory {
    func iosBuildArtifactsProvider(
        xcodebuildResult: XcodebuildResult
    ) -> IosBuildArtifactsProvider
}
