import Foundation

public final class RecordedSessionStubberImpl: RecordedSessionStubber {
    private let stubRequestBuilder: StubRequestBuilder
    
    public init(stubRequestBuilder: StubRequestBuilder) {
        self.stubRequestBuilder = stubRequestBuilder
    }
    
    public func stub(
        recordedStub: RecordedStub)
        throws
    {
        stubRequestBuilder
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
    
    public func stubAllNetworkInitially() {
        stubRequestBuilder
            .stub(urlPattern: ".*")
            .thenReturn(
                string: "All network is stubbed with error by default. If you see this then current request was not stubbed.",
                headers: [:],
                statusCode: 500,
                responseTime: 0
            )
    }
    
    // Very stupid regular expression! TODO: Improve! Add more things other than path and host.
    private func urlPattern(request: RecordedStubRequest) -> String {
        let trimmedPath = request.url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let pathAndQueryPattern: String
        let queryPattern: String = "($|\\?.*)"
        
        if trimmedPath.isEmpty {
            pathAndQueryPattern = "\\/?" + queryPattern
        } else {
            let pathPattern = NSRegularExpression.escapedPattern(
                for: trimmedPath
            )
            pathAndQueryPattern = "\\/" + pathPattern + "\\/?" + queryPattern
        }
        
        let hostPattern = request.url.host
            .flatMap {
                NSRegularExpression.escapedPattern(
                    for: $0.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                )
            }
            ?? ".*?"
        
        return "\(hostPattern)(:[0-9]+)?\(pathAndQueryPattern)"
    }
}
