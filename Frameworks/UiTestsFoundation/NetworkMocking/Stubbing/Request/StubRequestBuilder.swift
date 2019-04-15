// Do not use functions declared in protocol directly, use functions from extensions.
// This function should be used only for implementing basic functionality.
public protocol StubRequestBuilder {
    func withRequestStub(
        urlRegexPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    
    func withError(
        message: String)
        -> StubResponseBuilder
    
    func removeAllStubs()
}

extension StubRequestBuilder {
    // Example of fullUrl: ".*?example.com/rest/foo/[^/]+?/bar($|\\?.+$)"
    public func stub(
        urlPattern: String,
        query: [String]? = nil,
        httpMethod: HttpMethod? = nil)
        -> StubResponseBuilder
    {
        return withRequestStub(
            urlRegexPattern: urlPattern,
            query: query,
            httpMethod: httpMethod
        )
    }
}
