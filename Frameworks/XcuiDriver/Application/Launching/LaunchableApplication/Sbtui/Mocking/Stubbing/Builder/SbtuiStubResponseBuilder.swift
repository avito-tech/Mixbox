import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxReporting

enum StubResponseBuilderArgumentsBefore {
    case sbtuiStubRequest(SbtuiStubRequest)
    case error(String)
}

final class SbtuiStubResponseBuilder: StubResponseBuilder {
    private let stubResponseBuilderArgumentsBefore: StubResponseBuilderArgumentsBefore
    private let sbtuiStubApplier: SbtuiStubApplier
    private let testFailureRecorder: TestFailureRecorder
    
    init(
        stubResponseBuilderArgumentsBefore: StubResponseBuilderArgumentsBefore,
        sbtuiStubApplier: SbtuiStubApplier,
        testFailureRecorder: TestFailureRecorder)
    {
        self.stubResponseBuilderArgumentsBefore = stubResponseBuilderArgumentsBefore
        self.sbtuiStubApplier = sbtuiStubApplier
        self.testFailureRecorder = testFailureRecorder
    }
    
    func withResponse(
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
        responseTime: TimeInterval)
    {
        switch stubResponseBuilderArgumentsBefore {
        case .error(let message):
            testFailureRecorder.recordFailure(
                description: message,
                shouldContinueTest: false
            )
        case .sbtuiStubRequest(let sbtuiStubRequest):
            let stub = SbtuiStub(
                request: sbtuiStubRequest,
                response: SbtuiStubResponse(
                    value: value,
                    headers: headers,
                    statusCode: statusCode,
                    responseTime: responseTime
                )
            )
            
            sbtuiStubApplier.apply(stub: stub)
        }
    }
    
    
}
