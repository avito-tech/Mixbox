import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation

public final class SbtuiStubRequestBuilder: StubRequestBuilder {
    private let sbtuiStubApplier: SbtuiStubApplier
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        sbtuiStubApplier: SbtuiStubApplier,
        testFailureRecorder: TestFailureRecorder)
    {
        self.sbtuiStubApplier = sbtuiStubApplier
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func withRequestStub(
        urlPattern: String,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        let sbtuiStubRequest = SbtuiStubRequest(
            urlPattern: urlPattern,
            httpMethod: httpMethod
        )
        
        return SbtuiStubResponseBuilder(
            stubResponseBuilderArgumentsBefore: .sbtuiStubRequest(sbtuiStubRequest),
            sbtuiStubApplier: sbtuiStubApplier,
            testFailureRecorder: testFailureRecorder
        )
    }
    
    public func removeAllStubs() {
        sbtuiStubApplier.removeAllStubs()
    }
}
