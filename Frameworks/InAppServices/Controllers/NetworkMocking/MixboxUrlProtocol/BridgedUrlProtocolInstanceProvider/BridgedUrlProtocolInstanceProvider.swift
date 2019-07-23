#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

// Creates and provides same reference to BridgedUrlProtocolInstance.
//
// This class was created to handle circular dependency between URLProtocol and URLProtocolClient
// (MixboxUrlProtocol and BridgedUrlProtocolInstance). URLProtocol is initialized with URLProtocolClient.
// and URLProtocolClient receives URLProtocol in method calls as strong reference.
//
// The reason to create this class was to remove such code from MixboxUrlProtocol and just get ready instance there.
//
public final class BridgedUrlProtocolInstanceProvider {
    // Instance
    private var lazyBridgedUrlProtocolInstance: BridgedUrlProtocolInstance?
    
    // Injected from injection point #1.
    private let urlRequest: URLRequest
    private let cachedUrlResponse: CachedURLResponse?
    private weak var urlProtocolClient: URLProtocolClient?
    private let bridgedUrlProtocolClass: BridgedUrlProtocolClass
    private let urlRequestBridging: UrlRequestBridging
    private let urlResponseBridging: UrlResponseBridging
    private let cachedUrlResponseBridging: CachedUrlResponseBridging
    private let urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging
    
    // Injected from injection point #2.
    private weak var urlProtocol: URLProtocol?
    
    // Injection point #1.
    public init(
        urlRequest: URLRequest,
        cachedUrlResponse: CachedURLResponse?,
        urlProtocolClient: URLProtocolClient?,
        bridgedUrlProtocolClass: BridgedUrlProtocolClass,
        urlRequestBridging: UrlRequestBridging,
        urlResponseBridging: UrlResponseBridging,
        cachedUrlResponseBridging: CachedUrlResponseBridging,
        urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging)
    {
        self.urlRequest = urlRequest
        self.cachedUrlResponse = cachedUrlResponse
        self.urlProtocolClient = urlProtocolClient
        self.bridgedUrlProtocolClass = bridgedUrlProtocolClass
        self.urlRequestBridging = urlRequestBridging
        self.urlResponseBridging = urlResponseBridging
        self.cachedUrlResponseBridging = cachedUrlResponseBridging
        self.urlCacheStoragePolicyBridging = urlCacheStoragePolicyBridging
    }
    
    // Injection point #2.
    public func bridgedUrlProtocolInstance(urlProtocol: URLProtocol?) throws -> BridgedUrlProtocolInstance {
        if let instance = lazyBridgedUrlProtocolInstance {
            return instance
        } else {
            let instance = try makeBridgedUrlProtocolInstance(urlProtocol: urlProtocol)
            
            self.lazyBridgedUrlProtocolInstance = instance
            
            return instance
        }
    }
    
    private func makeBridgedUrlProtocolInstance(urlProtocol: URLProtocol?) throws -> BridgedUrlProtocolInstance {
        return try bridgedUrlProtocolClass.createInstance(
            request: try urlRequestBridging.bridgedUrlRequest(
                urlRequest: urlRequest
            ),
            cachedResponse: try cachedUrlResponse.map { cachedUrlResponse in
                try cachedUrlResponseBridging.bridgedCachedUrlResponse(
                    cachedUrlResponse: cachedUrlResponse
                )
            },
            client: InProcessBridgedUrlProtocolClient(
                urlProtocol: urlProtocol,
                urlProtocolClient: urlProtocolClient,
                urlRequestBridging: urlRequestBridging,
                urlResponseBridging: urlResponseBridging,
                cachedUrlResponseBridging: cachedUrlResponseBridging,
                urlCacheStoragePolicyBridging: urlCacheStoragePolicyBridging
            )
        )
    }
}

#endif
