#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

public final class UrlRequestCachePolicyBridgingImpl: UrlRequestCachePolicyBridging {
    public init() {
    }
    
    public func urlRequestCachePolicy(
        bridgedUrlRequestCachePolicy: BridgedUrlRequestCachePolicy)
        -> URLRequest.CachePolicy
    {
        switch bridgedUrlRequestCachePolicy {
        case .useProtocolCachePolicy:
            return .useProtocolCachePolicy
        case .reloadIgnoringLocalCacheData:
            return .reloadIgnoringLocalCacheData
        case .reloadIgnoringLocalAndRemoteCacheData:
            return .reloadIgnoringLocalAndRemoteCacheData
        case .returnCacheDataElseLoad:
            return .returnCacheDataElseLoad
        case .returnCacheDataDontLoad:
            return .returnCacheDataDontLoad
        case .reloadRevalidatingCacheData:
            return .reloadRevalidatingCacheData
        }
    }
    
    public func bridgedUrlRequestCachePolicy(
        urlRequestCachePolicy: URLRequest.CachePolicy)
        throws
        -> BridgedUrlRequestCachePolicy
    {
        switch urlRequestCachePolicy {
        case .useProtocolCachePolicy:
            return .useProtocolCachePolicy
        case .reloadIgnoringLocalCacheData:
            return .reloadIgnoringLocalCacheData
        case .reloadIgnoringLocalAndRemoteCacheData:
            return .reloadIgnoringLocalAndRemoteCacheData
        case .returnCacheDataElseLoad:
            return .returnCacheDataElseLoad
        case .returnCacheDataDontLoad:
            return .returnCacheDataDontLoad
        case .reloadRevalidatingCacheData:
            return .reloadRevalidatingCacheData
        @unknown default:
            throw UnsupportedEnumCaseError(urlRequestCachePolicy)
        }
    }
}

#endif
