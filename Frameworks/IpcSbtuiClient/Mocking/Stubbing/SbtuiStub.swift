import SBTUITestTunnel

public final class SbtuiStub {
    public let requestMatch: SBTRequestMatch
    public let stubResponse: SBTStubResponse
    
    public init(
        requestMatch: SBTRequestMatch,
        stubResponse: SBTStubResponse)
    {
        self.requestMatch = requestMatch
        self.stubResponse = stubResponse
    }
}
