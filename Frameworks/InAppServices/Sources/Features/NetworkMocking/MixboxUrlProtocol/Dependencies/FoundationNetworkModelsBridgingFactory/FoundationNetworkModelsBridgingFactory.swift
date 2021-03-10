#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol FoundationNetworkModelsBridgingFactory: class {
    var urlRequestBridging: UrlRequestBridging { get }
    var urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging { get }
    var urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging { get }
    var urlResponseBridging: UrlResponseBridging { get }
    var urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging { get }
    var cachedUrlResponseBridging: CachedUrlResponseBridging { get }
}

#endif
