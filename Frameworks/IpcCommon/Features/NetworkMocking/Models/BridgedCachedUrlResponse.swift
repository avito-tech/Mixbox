#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxAnyCodable

// Replicates CachedURLResponse
public final class BridgedCachedUrlResponse: Codable {
    public let response: BridgedUrlResponse
    public let data: Data
    public let userInfo: [String: AnyCodable]? // TODO: Deal with the restriction on the type of a key. Originally it was `[AnyHashable: Any]?`.
    public let storagePolicy: BridgedUrlCacheStoragePolicy
    
    public init(
        response: BridgedUrlResponse,
        data: Data,
        userInfo: [String: AnyCodable]?,
        storagePolicy: BridgedUrlCacheStoragePolicy)
    {
        self.response = response
        self.data = data
        self.userInfo = userInfo
        self.storagePolicy = storagePolicy
    }
}

#endif
