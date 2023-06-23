import MixboxIpcCommon

// TODO: It is unused. Use or delete.
public final class BridgedUrlRequestMatcherBuilder {
    public let url = PropertyMatcherBuilder("url", \BridgedUrlRequest.url)
    public let cachePolicy = PropertyMatcherBuilder("cachePolicy", \BridgedUrlRequest.cachePolicy)
    public let timeoutInterval = PropertyMatcherBuilder("timeoutInterval", \BridgedUrlRequest.timeoutInterval)
    public let mainDocumentUrl = PropertyMatcherBuilder("mainDocumentUrl", \BridgedUrlRequest.mainDocumentUrl)
    public let networkServiceType = PropertyMatcherBuilder("networkServiceType", \BridgedUrlRequest.networkServiceType)
    public let allowsCellularAccess = PropertyMatcherBuilder("allowsCellularAccess", \BridgedUrlRequest.allowsCellularAccess)
    public let httpMethod = PropertyMatcherBuilder("httpMethod", \BridgedUrlRequest.httpMethod)
    // public let allHTTPHeaderFields: [String: String]?
    public let httpBody = PropertyMatcherBuilder("httpBody", \BridgedUrlRequest.httpBody)
    public let httpShouldHandleCookies = PropertyMatcherBuilder("httpShouldHandleCookies", \BridgedUrlRequest.httpShouldHandleCookies)
    public let httpShouldUsePipelining = PropertyMatcherBuilder("httpShouldUsePipelining", \BridgedUrlRequest.httpShouldUsePipelining)
}
