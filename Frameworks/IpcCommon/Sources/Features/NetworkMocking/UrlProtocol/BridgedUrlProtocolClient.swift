#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
