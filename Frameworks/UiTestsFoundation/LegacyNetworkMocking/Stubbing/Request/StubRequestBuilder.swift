// Do not use functions declared in protocol directly, use functions from extensions.
// This function should be used only for implementing basic functionality.
public protocol StubRequestBuilder: class {
    func withRequestStub(
        // Example of urlPattern: ".*?example.com/rest/foo/[^/]+?/bar($|\\?.+$)"
        // urlPattern matches `URL.absoluteString`! So it can access query.
        urlPattern: String,
        // nil: do not match httpMethod
        httpMethod: HttpMethod?)
        -> StubResponseBuilder
    
    func removeAllStubs()
}

extension StubRequestBuilder {
    public func stub(
        // Example of urlPattern: ".*?example.com/rest/foo/[^/]+?/bar($|\\?.+$)"
        urlPattern: String,
        // nil: do not match httpMethod
        httpMethod: HttpMethod? = nil)
        -> StubResponseBuilder
    {
        return withRequestStub(
            urlPattern: urlPattern,
            httpMethod: httpMethod
        )
    }
}
