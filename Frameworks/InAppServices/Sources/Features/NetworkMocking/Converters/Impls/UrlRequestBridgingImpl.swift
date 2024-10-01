#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxIpcCommon
import MixboxFoundation

public final class UrlRequestBridgingImpl: UrlRequestBridging {
    private let urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging
    private let urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging
    
    public init(
        urlRequestCachePolicyBridging: UrlRequestCachePolicyBridging,
        urlRequestNetworkServiceTypeBridging: UrlRequestNetworkServiceTypeBridging)
    {
        self.urlRequestCachePolicyBridging = urlRequestCachePolicyBridging
        self.urlRequestNetworkServiceTypeBridging = urlRequestNetworkServiceTypeBridging
    }
    
    public func bridgedUrlRequest(
        urlRequest: URLRequest)
        throws
        -> BridgedUrlRequest
    {
        return BridgedUrlRequest(
            url: urlRequest.url,
            cachePolicy: try urlRequestCachePolicyBridging.bridgedUrlRequestCachePolicy(
                urlRequestCachePolicy: urlRequest.cachePolicy
            ),
            timeoutInterval: urlRequest.timeoutInterval,
            mainDocumentUrl: urlRequest.mainDocumentURL,
            networkServiceType: try urlRequestNetworkServiceTypeBridging.bridgedUrlRequestNetworkServiceType(
                urlRequestNetworkServiceType: urlRequest.networkServiceType
            ),
            allowsCellularAccess: urlRequest.allowsCellularAccess,
            httpMethod: urlRequest.httpMethod,
            allHTTPHeaderFields: urlRequest.allHTTPHeaderFields,
            httpBody: urlRequest.httpBody,
            httpShouldHandleCookies: urlRequest.httpShouldHandleCookies,
            httpShouldUsePipelining: urlRequest.httpShouldUsePipelining
        )
    }
    
    public func urlRequest(bridgedUrlRequest: BridgedUrlRequest) throws -> URLRequest {
        var request = URLRequest(
            url: bridgedUrlRequest.url ?? URL(
                fileURLWithPath: "ThisUrlShouldntBeUsedAnywhereAndWasCreatedToWorkaroundOptionalityOfUrlInTheInitOfURLResponses"
            ),
            cachePolicy: try urlRequestCachePolicyBridging.urlRequestCachePolicy(
                bridgedUrlRequestCachePolicy: bridgedUrlRequest.cachePolicy
            ),
            timeoutInterval: bridgedUrlRequest.timeoutInterval
        )
        
        // Fields with wrong optionality in init:
        request.url = bridgedUrlRequest.url
        
        // Fields that are not in init:
        request.mainDocumentURL = bridgedUrlRequest.mainDocumentUrl
        request.networkServiceType = try urlRequestNetworkServiceTypeBridging.urlRequestNetworkServiceType(
            bridgedUrlRequestNetworkServiceType: bridgedUrlRequest.networkServiceType
        )
        request.allowsCellularAccess = bridgedUrlRequest.allowsCellularAccess
        request.httpMethod = bridgedUrlRequest.httpMethod
        request.allHTTPHeaderFields = bridgedUrlRequest.allHTTPHeaderFields
        request.httpBody = bridgedUrlRequest.httpBody
        request.httpShouldHandleCookies = bridgedUrlRequest.httpShouldHandleCookies
        request.httpShouldUsePipelining = bridgedUrlRequest.httpShouldUsePipelining
        
        return request
    }
}

#endif
