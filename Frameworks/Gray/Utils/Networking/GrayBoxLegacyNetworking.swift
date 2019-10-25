import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class GrayBoxLegacyNetworking: LegacyNetworking {
    public let stubbing: LegacyNetworkStubbing
    
    public var recording: LegacyNetworkRecording {
        grayNotImplemented()
    }
    
    public init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.stubbing = GrayBoxLegacyNetworkStubbing(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: testFailureRecorder,
            waiter: waiter,
            bundleResourcePathProvider: bundleResourcePathProvider
        )
    }
}
