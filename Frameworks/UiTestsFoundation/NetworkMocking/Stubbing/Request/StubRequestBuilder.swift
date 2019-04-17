// Do not use functions declared in protocol directly, use functions from extensions.
// This function should be used only for implementing basic functionality.
public protocol StubRequestBuilder {
    func withRequestStub(
        // Example of urlPattern: ".*?example.com/rest/foo/[^/]+?/bar($|\\?.+$)"
        // urlPattern matches `URL.absoluteString`! So it can access query.
        urlPattern: String,
        // nil: do not match query, [] - match empty query
        query: [String]?,
        // nil: do not match httpMethod
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    
    func removeAllStubs()
}

extension StubRequestBuilder {
    public func stub(
        // Example of urlPattern: ".*?example.com/rest/foo/[^/]+?/bar($|\\?.+$)"
        urlPattern: String,
        // nil: do not match query, [] - match empty query
        query: [String]? = nil,
        // nil: do not match httpMethod
        httpMethod: HttpMethod? = nil)
        -> StubResponseBuilder
    {
        return withRequestStub(
            urlPattern: urlPattern,
            query: query,
            httpMethod: httpMethod
        )
    }
    
    public func stub(
        recordedStub: RecordedStub)
        throws
    {
        self
            .stub(
                urlPattern: urlPattern(
                    request: recordedStub.request
                ),
                httpMethod: recordedStub.request.httpMethod
            )
            .thenReturn(
                data: try recordedStub.response.data.data(),
                headers: recordedStub.response.headers,
                statusCode: recordedStub.response.statusCode
            )
    }
    
    // Very stupid regular expression! TODO: Improve! Add more things other than path and host.
    private func urlPattern(request: RecordedStubRequest) -> String {
        let path = request.url.path
        let pathAndQueryPattern: String
        if path.isEmpty {
            pathAndQueryPattern = "/?(?:$|\\?.*)"
        } else {
            pathAndQueryPattern = "/" + NSRegularExpression.escapedPattern(for: path) + "(?:$|\\?.*)"
        }
        let hostPattern = request.url.host.flatMap { NSRegularExpression.escapedPattern(for: $0) } ?? ".*?"
        
        return "\(hostPattern)\(pathAndQueryPattern)"
    }
}
