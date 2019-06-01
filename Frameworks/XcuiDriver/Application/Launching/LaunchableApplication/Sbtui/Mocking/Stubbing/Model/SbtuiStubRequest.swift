import SBTUITestTunnel
import MixboxUiTestsFoundation

public final class SbtuiStubRequest: Hashable {
    public let urlPattern: String
    public let query: [String]?
    public let httpMethod: HttpMethod?
    
    public init(
        urlPattern: String,
        query: [String]?,
        httpMethod: HttpMethod?)
    {
        self.urlPattern = urlPattern
        self.query = query
        self.httpMethod = httpMethod
    }
    
    // TODO: Fix nullability in SBTUITestTunnel.
    // A single init with optional fields will be better, because everything is optional inside this class.
    public var requestMatch: SBTRequestMatch {
        switch (query, httpMethod) {
        case let (.some(query), .some(httpMethod)):
            return SBTRequestMatch(
                url: urlPattern,
                query: query,
                method: httpMethod.value
            )
        case let (.none, .some(httpMethod)):
            return SBTRequestMatch(
                url: urlPattern,
                method: httpMethod.value
            )
        case let (.some(query), .none):
            return SBTRequestMatch(
                url: urlPattern,
                query: query
            )
        case (.none, .none):
            return SBTRequestMatch(
                url: urlPattern
            )
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(urlPattern)
        hasher.combine(query)
        hasher.combine(httpMethod)
    }
    
    public static func ==(l: SbtuiStubRequest, r: SbtuiStubRequest) -> Bool {
        return l.urlPattern == r.urlPattern
            && l.query == r.query
            && l.httpMethod == r.httpMethod
    }
}
