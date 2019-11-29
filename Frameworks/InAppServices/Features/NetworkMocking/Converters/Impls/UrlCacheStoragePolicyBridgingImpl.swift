#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

public final class UrlCacheStoragePolicyBridgingImpl: UrlCacheStoragePolicyBridging {
    public init() {
    }
    
    public func urlCacheStoragePolicy(
        bridgedUrlCacheStoragePolicy: BridgedUrlCacheStoragePolicy)
        -> URLCache.StoragePolicy
    {
        switch bridgedUrlCacheStoragePolicy {
        case .allowed:
            return .allowed
        case .allowedInMemoryOnly:
            return .allowedInMemoryOnly
        case .notAllowed:
            return .notAllowed
        }
    }
    
    public func bridgedUrlCacheStoragePolicy(
        urlCacheStoragePolicy: URLCache.StoragePolicy)
        throws
        -> BridgedUrlCacheStoragePolicy
    {
        switch urlCacheStoragePolicy {
        case .allowed:
            return .allowed
        case .allowedInMemoryOnly:
            return .allowedInMemoryOnly
        case .notAllowed:
            return .notAllowed
        @unknown default:
            throw UnsupportedEnumCaseError(urlCacheStoragePolicy)
        }
    }
}

#endif
