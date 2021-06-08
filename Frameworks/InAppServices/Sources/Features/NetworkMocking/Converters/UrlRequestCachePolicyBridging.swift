#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol UrlRequestCachePolicyBridging: AnyObject {
    func urlRequestCachePolicy(
        bridgedUrlRequestCachePolicy: BridgedUrlRequestCachePolicy)
        throws
        -> URLRequest.CachePolicy
    
    func bridgedUrlRequestCachePolicy(
        urlRequestCachePolicy: URLRequest.CachePolicy)
        throws
        -> BridgedUrlRequestCachePolicy
}

#endif
