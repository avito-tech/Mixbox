#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public protocol FoundationNetworkModelsBridgingFactory: AnyObject {
    var urlRequestBridging: UrlRequestBridging { get }
    var urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging { get }
    var urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging { get }
    var urlResponseBridging: UrlResponseBridging { get }
    var urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging { get }
    var cachedUrlResponseBridging: CachedUrlResponseBridging { get }
}

#endif
