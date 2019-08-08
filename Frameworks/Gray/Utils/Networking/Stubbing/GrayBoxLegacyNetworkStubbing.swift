import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxReporting

public final class GrayBoxLegacyNetworkStubbing: LegacyNetworkStubbing {
    private let testFailureRecorder: TestFailureRecorder
    private let spinner: Spinner
    
    private let bridgedUrlProtocolClass: GrayBoxLegacyNetworkStubbingBridgedUrlProtocolClass
    
    public init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        spinner: Spinner,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.spinner = spinner
        
        self.bridgedUrlProtocolClass = GrayBoxLegacyNetworkStubbingBridgedUrlProtocolClass(
            urlProtocolStubAdder: urlProtocolStubAdder,
            testFailureRecorder: testFailureRecorder,
            bundleResourcePathProvider: bundleResourcePathProvider
        )
    }
    
    public func withRequestStub(
        urlPattern: String,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        return GrayBoxLegacyNetworkStubbingStubResponseBuilder(
            urlPattern: urlPattern,
            httpMethod: httpMethod,
            grayBoxLegacyNetworkStubbingNetworkStubRepository: bridgedUrlProtocolClass,
            testFailureRecorder: testFailureRecorder,
            spinner: spinner
        )
    }
    
    public func removeAllStubs() {
        bridgedUrlProtocolClass.removeAllStubs()
    }
}
