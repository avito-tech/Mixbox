import SBTUITestTunnel
import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxReporting

enum StubResponseBuilderArgumentsBefore {
    case requestMatch(SBTRequestMatch)
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
        case .requestMatch(let requestMatch):
            let stub = SbtuiStub(
                requestMatch: requestMatch,
                stubResponse: stubResponse(
                    value: value,
                    headers: headers,
                    statusCode: statusCode,
                    responseTime: responseTime
                )
            )
            
            sbtuiStubApplier.apply(stub: stub)
        }
    }
    
    func stubResponse(
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
        responseTime: TimeInterval)
        -> SBTStubResponse
    {
        switch value {
        case .data(let data):
            return SBTStubResponse(
                response: data,
                headers: headers,
                returnCode: statusCode,
                responseTime: responseTime
            )
        case .file(let file):
            return SBTStubResponse(
                fileNamed: file,
                headers: headers,
                returnCode: statusCode,
                responseTime: responseTime
            )
        case .string(let string):
            return SBTStubResponse(
                response: string,
                headers: headers,
                returnCode: statusCode,
                responseTime: responseTime
            )
        }
    }
}
