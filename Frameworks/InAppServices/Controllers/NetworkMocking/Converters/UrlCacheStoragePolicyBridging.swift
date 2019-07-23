#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol UrlCacheStoragePolicyBridging: class {
    func urlCacheStoragePolicy(
        bridgedUrlCacheStoragePolicy: BridgedUrlCacheStoragePolicy)
        throws
        -> URLCache.StoragePolicy
    
    func bridgedUrlCacheStoragePolicy(
        urlCacheStoragePolicy: URLCache.StoragePolicy)
        throws
        -> BridgedUrlCacheStoragePolicy
}

#endif
