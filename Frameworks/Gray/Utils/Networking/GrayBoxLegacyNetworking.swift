import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxGray
import MixboxReporting

public final class GrayBoxLegacyNetworking: LegacyNetworking {
    public let stubbing: LegacyNetworkStubbing
    
    public var recording: LegacyNetworkRecording {
        grayNotImplemented()
    }
    
    public init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.stubbing = GrayBoxLegacyNetworkStubbing(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: testFailureRecorder,
            spinner: spinner,
            bundleResourcePathProvider: bundleResourcePathProvider
        )
    }
}
