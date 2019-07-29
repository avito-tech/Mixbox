import SBTUITestTunnel
import MixboxUiTestsFoundation

public final class SbtuiStubRequest: Hashable {
    public let urlPattern: String
    public let httpMethod: HttpMethod?
    
    public init(
        urlPattern: String,
        httpMethod: HttpMethod?)
    {
        self.urlPattern = urlPattern
        self.httpMethod = httpMethod
    }
    
    // TODO: Fix nullability in SBTUITestTunnel.
    // A single init with optional fields will be better, because everything is optional inside this class.
    public var requestMatch: SBTRequestMatch {
        if let httpMethod = httpMethod {
            return SBTRequestMatch(
                url: urlPattern,
                method: httpMethod.value
            )
        } else {
            return SBTRequestMatch(
                url: urlPattern
            )
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(urlPattern)
        hasher.combine(httpMethod)
    }
    
    public static func ==(l: SbtuiStubRequest, r: SbtuiStubRequest) -> Bool {
        return l.urlPattern == r.urlPattern
            && l.httpMethod == r.httpMethod
    }
}
