public final class RecordedStub: Codable, Equatable {
    public let request: RecordedStubRequest
    public let response: RecordedStubResponse
    
    public init(
        request: RecordedStubRequest,
        response: RecordedStubResponse)
    {
        self.request = request
        self.response = response
    }
    
    public static func ==(l: RecordedStub, r: RecordedStub) -> Bool {
        return l.request == r.request
            && l.response == r.response
    }
}
