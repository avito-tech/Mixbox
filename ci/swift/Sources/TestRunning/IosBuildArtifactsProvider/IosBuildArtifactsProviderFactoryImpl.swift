import Xcodebuild
import BuildArtifactsApple

public final class IosBuildArtifactsProviderFactoryImpl: IosBuildArtifactsProviderFactory {
    private let testDiscoveryMode: XcTestBundleTestDiscoveryMode
    
    public init(
        testDiscoveryMode: XcTestBundleTestDiscoveryMode
    ) {
        self.testDiscoveryMode = testDiscoveryMode
    }
    
    public func iosBuildArtifactsProvider(
        xcodebuildResult: XcodebuildResult
    ) -> IosBuildArtifactsProvider {
        IosBuildArtifactsProviderImpl(
            xcodebuildResult: xcodebuildResult,
            testDiscoveryMode: testDiscoveryMode
        )
    }
}
