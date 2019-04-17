public final class NetworkStubbingImpl: NetworkStubbing {
    private let stubRequestBuilder: StubRequestBuilder
    
    public init(
        stubRequestBuilder: StubRequestBuilder)
    {
        self.stubRequestBuilder = stubRequestBuilder
    }
    
    // MARK: - StubRequestBuilder
    
    public func withRequestStub(
        urlPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    {
        return stubRequestBuilder.withRequestStub(
            urlPattern: urlPattern,
            query: query,
            httpMethod: httpMethod
        )
    }
    
    public func removeAllStubs() {
        return stubRequestBuilder.removeAllStubs()
    }
}
