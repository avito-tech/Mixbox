#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class FoundationNetworkModelsBridgingFactoryImpl: FoundationNetworkModelsBridgingFactory {
    public let urlRequestBridging: UrlRequestBridging
    public let urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging
    public let urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging
    public let urlResponseBridging: UrlResponseBridging
    public let urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging
    public let cachedUrlResponseBridging: CachedUrlResponseBridging
    
    public init() {
        urlRequestNetworkServiceTypeBridging = UrlRequestNetworkServiceTypeBridgingImpl()
        urlRequestCachePolicyBridging = UrlRequestCachePolicyBridgingImpl()
        urlRequestBridging = UrlRequestBridgingImpl(
            urlRequestCachePolicyBridging: urlRequestCachePolicyBridging,
            urlRequestNetworkServiceTypeBridging: urlRequestNetworkServiceTypeBridging
        )
        urlResponseBridging = UrlResponseBridgingImpl()
        urlCacheStoragePolicyBridging = UrlCacheStoragePolicyBridgingImpl()
        cachedUrlResponseBridging = CachedUrlResponseBridgingImpl(
            urlResponseBridging: urlResponseBridging,
            urlCacheStoragePolicyBridging: urlCacheStoragePolicyBridging
        )
    }
}

#endif
