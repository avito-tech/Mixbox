#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxFoundation

public final class MixboxUrlProtocolDependencies {
    public let bridgedUrlProtocolClass: BridgedUrlProtocolClass
    public let foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactory
    public let assertionFailureRecorder: AssertionFailureRecorder
    
    // For convenience (duplicates foundationNetworkModelsBridgingFactory)
    public let urlRequestBridging: UrlRequestBridging
    public let urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging
    public let urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging
    public let urlResponseBridging: UrlResponseBridging
    public let urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging
    public let cachedUrlResponseBridging: CachedUrlResponseBridging
    
    public init(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass,
        foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactory,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.bridgedUrlProtocolClass = bridgedUrlProtocolClass
        self.foundationNetworkModelsBridgingFactory = foundationNetworkModelsBridgingFactory
        self.assertionFailureRecorder = assertionFailureRecorder
        
        self.urlRequestBridging = foundationNetworkModelsBridgingFactory.urlRequestBridging
        self.urlRequestCachePolicyBridging = foundationNetworkModelsBridgingFactory.urlRequestCachePolicyBridging
        self.urlRequestNetworkServiceTypeBridging = foundationNetworkModelsBridgingFactory.urlRequestNetworkServiceTypeBridging
        self.urlResponseBridging = foundationNetworkModelsBridgingFactory.urlResponseBridging
        self.urlCacheStoragePolicyBridging = foundationNetworkModelsBridgingFactory.urlCacheStoragePolicyBridging
        self.cachedUrlResponseBridging = foundationNetworkModelsBridgingFactory.cachedUrlResponseBridging
    }
}

#endif
