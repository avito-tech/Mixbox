#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

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
        -> BridgedUrlCacheStoragePolicy
    {
        switch urlCacheStoragePolicy {
        case .allowed:
            return .allowed
        case .allowedInMemoryOnly:
            return .allowedInMemoryOnly
        case .notAllowed:
            return .notAllowed
        }
    }
}

#endif
