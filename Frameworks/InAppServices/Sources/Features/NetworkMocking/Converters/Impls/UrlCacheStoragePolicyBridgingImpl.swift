#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
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
