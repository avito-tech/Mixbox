#if MIXBOX_ENABLE_IN_APP_SERVICES

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
