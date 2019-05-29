import SBTUITestTunnel
import MixboxUiTestsFoundation

public final class SbtuiStubResponse {
    public let value: StubResponseBuilderResponseValue
    public let headers: [String: String]
    public let statusCode: Int
    public let responseTime: TimeInterval
    
    public init(
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
        responseTime: TimeInterval)
    {
        self.value = value
        self.headers = headers
        self.statusCode = statusCode
        self.responseTime = responseTime
    }
    
    public var stubResponse: SBTStubResponse {
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
