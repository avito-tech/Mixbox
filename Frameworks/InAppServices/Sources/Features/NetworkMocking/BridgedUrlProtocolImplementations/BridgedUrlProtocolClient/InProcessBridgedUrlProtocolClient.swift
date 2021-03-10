#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

// In-process implementation of BridgedUrlProtocolClient (literally bridged `URLProtocolClient`)
// can access URLProtocolClient directly. This is the purpose of `BridgedUrlProtocolClient`. For example,
// `IpcBridgedUrlProtocolClient`accesses `URLProtocolClient` via IPC, which works using IPC with this class.
// Think of this class as a destination for `IpcBridgedUrlProtocolClient`.
public final class InProcessBridgedUrlProtocolClient: BridgedUrlProtocolClient, IpcObjectIdentifiable {
    public let ipcObjectId: IpcObjectId = .uuid
    
    private weak var urlProtocol: URLProtocol?
    private weak var urlProtocolClient: URLProtocolClient?
    
    private let urlRequestBridging: UrlRequestBridging
    private let urlResponseBridging: UrlResponseBridging
    private let cachedUrlResponseBridging: CachedUrlResponseBridging
    private let urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging
    
    public init(
        urlProtocol: URLProtocol?,
        urlProtocolClient: URLProtocolClient?,
        urlRequestBridging: UrlRequestBridging,
        urlResponseBridging: UrlResponseBridging,
        cachedUrlResponseBridging: CachedUrlResponseBridging,
        urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging)
    {
        self.urlProtocol = urlProtocol
        self.urlProtocolClient = urlProtocolClient
        self.urlRequestBridging = urlRequestBridging
        self.urlResponseBridging = urlResponseBridging
        self.cachedUrlResponseBridging = cachedUrlResponseBridging
        self.urlCacheStoragePolicyBridging = urlCacheStoragePolicyBridging
    }
    
    public func urlProtocolWasRedirectedTo(
        request: BridgedUrlRequest,
        redirectResponse: BridgedUrlResponse)
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocol(
                urlProtocol,
                wasRedirectedTo: try urlRequestBridging.urlRequest(
                    bridgedUrlRequest: request
                ),
                redirectResponse: try urlResponseBridging.urlResponse(
                    bridgedUrlResponse: redirectResponse
                )
            )
        }
    }
    
    public func urlProtocolCachedResponseIsValid(
        cachedResponse: BridgedCachedUrlResponse)
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocol(
                urlProtocol,
                cachedResponseIsValid: try cachedUrlResponseBridging.cachedUrlResponse(
                    bridgedCachedUrlResponse: cachedResponse
                )
            )
        }
    }
    
    public func urlProtocolDidReceive(
        response: BridgedUrlResponse,
        cacheStoragePolicy: BridgedUrlCacheStoragePolicy)
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocol(
                urlProtocol,
                didReceive: try urlResponseBridging.urlResponse(
                    bridgedUrlResponse: response
                ),
                cacheStoragePolicy: try urlCacheStoragePolicyBridging.urlCacheStoragePolicy(
                    bridgedUrlCacheStoragePolicy: cacheStoragePolicy
                )
            )
        }
    }
    
    public func urlProtocolDidLoad(
        data: Data)
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocol(
                urlProtocol,
                didLoad: data
            )
        }
    }
    
    public func urlProtocolDidFailWithError(
        error: String)
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocol(
                urlProtocol,
                didFailWithError: ErrorString(error)
            )
        }
    }
    
    public func urlProtocolDidFinishLoading()
        throws
    {
        try call { urlProtocolClient, urlProtocol in
            urlProtocolClient.urlProtocolDidFinishLoading(
                urlProtocol
            )
        }
    }
    
    // MARK: - Private
    
    private func call(
        _ closure: (URLProtocolClient, URLProtocol) throws -> ())
        throws
    {
        guard let urlProtocolClient = urlProtocolClient else {
            throw ErrorString("urlProtocolClient is nil in call() in \(type(of: self)), which is unexpected")
        }
        
        guard let urlProtocol = urlProtocol else {
            throw ErrorString("urlProtocol is nil in call() in \(type(of: self)), which is unexpected")
        }
        
        try closure(urlProtocolClient, urlProtocol)
    }
}

#endif
