#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

// Replicates URLProtocolClient
public protocol BridgedUrlProtocolClient: AnyObject {
    func urlProtocolWasRedirectedTo(request: BridgedUrlRequest, redirectResponse: BridgedUrlResponse) throws
    func urlProtocolCachedResponseIsValid(cachedResponse: BridgedCachedUrlResponse) throws
    func urlProtocolDidReceive(response: BridgedUrlResponse, cacheStoragePolicy: BridgedUrlCacheStoragePolicy) throws
    func urlProtocolDidLoad(data: Data) throws
    func urlProtocolDidFailWithError(error: String) throws
    func urlProtocolDidFinishLoading() throws
    
    // Not supported:
    // public func urlProtocolDidReceive(challenge: BridgedUrlAuthenticationChallenge)
    // public func urlProtocolDidCancel(challenge: BridgedUrlAuthenticationChallenge)
}

#endif
