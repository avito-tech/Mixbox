#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolCachedResponseIsValidIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let bridgedCachedUrlResponse: BridgedCachedUrlResponse
        
        public init(
            selfIpcObjectId: IpcObjectId,
            bridgedCachedUrlResponse: BridgedCachedUrlResponse)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.bridgedCachedUrlResponse = bridgedCachedUrlResponse
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
        
    }
}

#endif
