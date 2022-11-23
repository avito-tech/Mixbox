#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import Foundation

// Replicates URLRequest
public final class BridgedUrlRequest: Codable {
    public let url: URL?
    public let cachePolicy: BridgedUrlRequestCachePolicy
    public let timeoutInterval: TimeInterval
    public let mainDocumentUrl: URL?
    public let networkServiceType: BridgedUrlRequestNetworkServiceType
    public let allowsCellularAccess: Bool
    public let httpMethod: String?
    public let allHTTPHeaderFields: [String: String]?
    public let httpBody: Data?
    // TODO: Support if it really can be used. Or remove.
    // public let httpBodyStream: InputStream?
    public let httpShouldHandleCookies: Bool
    public let httpShouldUsePipelining: Bool
    
    public init(
        url: URL?,
        cachePolicy: BridgedUrlRequestCachePolicy,
        timeoutInterval: TimeInterval,
        mainDocumentUrl: URL?,
        networkServiceType: BridgedUrlRequestNetworkServiceType,
        allowsCellularAccess: Bool,
        httpMethod: String?,
        allHTTPHeaderFields: [String: String]?,
        httpBody: Data?,
        // httpBodyStream: InputStream?,
        httpShouldHandleCookies: Bool,
        httpShouldUsePipelining: Bool)
    {
        self.url = url
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.mainDocumentUrl = mainDocumentUrl
        self.networkServiceType = networkServiceType
        self.allowsCellularAccess = allowsCellularAccess
        self.httpMethod = httpMethod
        self.allHTTPHeaderFields = allHTTPHeaderFields
        self.httpBody = httpBody
        // self.httpBodyStream = httpBodyStream
        self.httpShouldHandleCookies = httpShouldHandleCookies
        self.httpShouldUsePipelining = httpShouldUsePipelining
    }
}

#endif
