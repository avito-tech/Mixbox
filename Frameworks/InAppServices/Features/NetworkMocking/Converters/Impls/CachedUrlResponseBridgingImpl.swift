#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxAnyCodable
import MixboxFoundation
import Foundation

public final class CachedUrlResponseBridgingImpl: CachedUrlResponseBridging {
    private let urlResponseBridging: UrlResponseBridging
    private let urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging
    
    public init(
        urlResponseBridging: UrlResponseBridging,
        urlCacheStoragePolicyBridging: UrlCacheStoragePolicyBridging)
    {
        self.urlResponseBridging = urlResponseBridging
        self.urlCacheStoragePolicyBridging = urlCacheStoragePolicyBridging
    }
    
    public func bridgedCachedUrlResponse(
        cachedUrlResponse: CachedURLResponse)
        throws
        -> BridgedCachedUrlResponse
    {
        return BridgedCachedUrlResponse(
            response: try urlResponseBridging.bridgedUrlResponse(
                urlResponse: cachedUrlResponse.response
            ),
            data: cachedUrlResponse.data,
            userInfo: try cachedUrlResponse.userInfo.map {
                try toAnyCodable(userInfo: $0)
            },
            storagePolicy: try urlCacheStoragePolicyBridging.bridgedUrlCacheStoragePolicy(
                urlCacheStoragePolicy: cachedUrlResponse.storagePolicy
            )
        )
    }
    
    public func cachedUrlResponse(
        bridgedCachedUrlResponse: BridgedCachedUrlResponse)
        throws
        -> CachedURLResponse
    {
        return CachedURLResponse(
            response: try urlResponseBridging.urlResponse(
                bridgedUrlResponse: bridgedCachedUrlResponse.response
            ),
            data: bridgedCachedUrlResponse.data,
            userInfo: bridgedCachedUrlResponse.userInfo,
            storagePolicy: try urlCacheStoragePolicyBridging.urlCacheStoragePolicy(
                bridgedUrlCacheStoragePolicy: bridgedCachedUrlResponse.storagePolicy
            )
        )
    }
    
    private func toAnyCodable(userInfo: [AnyHashable : Any]) throws -> [String: AnyCodable] {
        var encodableUserInfo = [String: AnyCodable]()
        
        for (key, value) in userInfo {
            if let stringKey = key as? String {
                encodableUserInfo[stringKey] = AnyCodable(value)
            } else {
                throw ErrorString(
                    """
                    Unsupported type of key in userInfo in \
                    CachedUrlResponseBridgingImpl.toAnyCodable(userInfo:): '\(type(of: key))'. \
                    Currently only String is supported
                    """
                )
            }
        }
        
        return try convertValueToCodableAndImmutable(source: encodableUserInfo)
    }
    
    // Adds overhead, but guarantees deterministic result.
    // The idea is to throw exception if encoding/decoding fails.
    // And there also might be some mutable classes like NSMutableString.
    // The function makes everything immutable and returns only if result is codable.
    // There can be more straightforward way to do this, but this implementation is simple.
    private func convertValueToCodableAndImmutable(source: [String: AnyCodable]) throws -> [String: AnyCodable] {
        let encoded = try JSONEncoder().encode(source)
        let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: encoded)
        
        return decoded
    }
}

#endif
