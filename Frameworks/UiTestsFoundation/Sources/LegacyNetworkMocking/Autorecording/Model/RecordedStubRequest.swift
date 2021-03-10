import Foundation

public final class RecordedStubRequest: Codable, Equatable {
    public let url: URL
    public let httpMethod: HttpMethod
    
    public init(
        url: URL,
        httpMethod: HttpMethod)
    {
        self.url = url
        self.httpMethod = httpMethod
    }
    
    public static func ==(l: RecordedStubRequest, r: RecordedStubRequest) -> Bool {
        return l.url == r.url
    }
}
