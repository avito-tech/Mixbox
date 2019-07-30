import MixboxUiTestsFoundation
import MixboxIpcCommon

public class GrayBoxLegacyNetworkStubbingNetworkStub {
    public let urlPattern: String
    public let httpMethod: HttpMethod?
    public let value: StubResponseBuilderResponseValue
    public let headers: [String: String]
    public let statusCode: Int
    public let responseTime: TimeInterval
    
    public let urlRegex: NSRegularExpression
    
    public init(
        urlPattern: String,
        httpMethod: HttpMethod?,
        value: StubResponseBuilderResponseValue,
        headers: [String: String],
        statusCode: Int,
        responseTime: TimeInterval)
        throws
    {
        self.urlPattern = urlPattern
        self.httpMethod = httpMethod
        self.value = value
        self.headers = headers
        self.statusCode = statusCode
        self.responseTime = responseTime
        
        urlRegex = try NSRegularExpression(
            pattern: urlPattern,
            options: []
        )
    }
    
    public func matches(request: BridgedUrlRequest) -> Bool {
        return urlMatches(request: request)
            && httpMethodMatches(request: request)
    }
    
    private func urlMatches(request: BridgedUrlRequest) -> Bool {
        guard let url = request.url else {
            return false
        }
        
        let stringForUrlRegex = url.absoluteString
        
        let firstMatch = urlRegex.firstMatch(
            in: stringForUrlRegex,
            range: NSRange(location: 0, length: (stringForUrlRegex as NSString).length)
        )
        
        return firstMatch != nil
    }
    
    private func httpMethodMatches(request: BridgedUrlRequest) -> Bool {
        guard let httpMethod = httpMethod else {
            return true
        }
        
        guard let requestHttpMethod = request.httpMethod else {
            return false
        }
        
        return httpMethod.rawValue.lowercased() == requestHttpMethod.lowercased()
    }
}
