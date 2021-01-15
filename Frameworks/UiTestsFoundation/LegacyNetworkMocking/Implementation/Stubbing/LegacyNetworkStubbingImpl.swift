import MixboxTestsFoundation
import MixboxFoundation

public final class LegacyNetworkStubbingImpl: LegacyNetworkStubbing {
    private let testFailureRecorder: TestFailureRecorder
    private let waiter: RunLoopSpinningWaiter
    
    private let bridgedUrlProtocolClass: LegacyNetworkBridgedUrlProtocolClass
    
    public init(
        urlProtocolStubAdder: UrlProtocolStubAdder,
        testFailureRecorder: TestFailureRecorder,
        waiter: RunLoopSpinningWaiter,
        bundleResourcePathProvider: BundleResourcePathProvider)
    {
        self.testFailureRecorder = testFailureRecorder
        self.waiter = waiter
        
        self.bridgedUrlProtocolClass = LegacyNetworkBridgedUrlProtocolClass(
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
        return StubResponseBuilderImpl(
            urlPattern: urlPattern,
            httpMethod: httpMethod,
            legacyNetworkStubRepository: bridgedUrlProtocolClass,
            testFailureRecorder: testFailureRecorder,
            waiter: waiter
        )
    }
    
    public func removeAllStubs() {
        bridgedUrlProtocolClass.removeAllStubs()
    }
}
