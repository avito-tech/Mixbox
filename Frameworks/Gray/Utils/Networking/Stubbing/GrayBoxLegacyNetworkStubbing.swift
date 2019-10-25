import MixboxTestsFoundation
import MixboxUiTestsFoundation

public final class GrayBoxLegacyNetworkStubbing: LegacyNetworkStubbing {
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    
    private let bridgedUrlProtocolClass: GrayBoxLegacyNetworkStubbingBridgedUrlProtocolClass
    
    public init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
        
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
            waiter: waiter
        )
    }
    
    public func removeAllStubs() {
        bridgedUrlProtocolClass.removeAllStubs()
    }
}
