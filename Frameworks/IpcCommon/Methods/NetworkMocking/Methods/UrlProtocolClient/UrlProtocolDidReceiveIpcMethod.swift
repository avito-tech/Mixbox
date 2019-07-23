#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolDidReceiveIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let bridgedUrlResponse: BridgedUrlResponse
        public let bridgedUrlCacheStoragePolicy: BridgedUrlCacheStoragePolicy
        
        public init(
            selfIpcObjectId: IpcObjectId,
            bridgedUrlResponse: BridgedUrlResponse,
            bridgedUrlCacheStoragePolicy: BridgedUrlCacheStoragePolicy)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.bridgedUrlResponse = bridgedUrlResponse
            self.bridgedUrlCacheStoragePolicy = bridgedUrlCacheStoragePolicy
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
        
    }
}

#endif
