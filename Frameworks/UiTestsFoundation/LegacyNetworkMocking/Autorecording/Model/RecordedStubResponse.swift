public final class RecordedStubResponse: Codable, Equatable {
    public let data: RecordedStubResponseData
    public let headers: [String: String]
    public let statusCode: Int
    
    public init(
        data: RecordedStubResponseData,
        headers: [String: String],
        statusCode: Int)
    {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
    }
    
    public static func ==(l: RecordedStubResponse, r: RecordedStubResponse) -> Bool {
        return l.data == r.data
            && l.headers == r.headers
            && l.statusCode == r.statusCode
    }
}
