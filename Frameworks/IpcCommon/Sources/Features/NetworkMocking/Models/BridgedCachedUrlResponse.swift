#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxAnyCodable
import Foundation

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
