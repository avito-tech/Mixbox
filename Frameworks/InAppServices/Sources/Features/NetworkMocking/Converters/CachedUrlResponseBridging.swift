#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public protocol CachedUrlResponseBridging: class {
    func bridgedCachedUrlResponse(
        cachedUrlResponse: CachedURLResponse)
        throws
        -> BridgedCachedUrlResponse
    
    func cachedUrlResponse(
        bridgedCachedUrlResponse: BridgedCachedUrlResponse)
        throws
        -> CachedURLResponse
}

#endif
