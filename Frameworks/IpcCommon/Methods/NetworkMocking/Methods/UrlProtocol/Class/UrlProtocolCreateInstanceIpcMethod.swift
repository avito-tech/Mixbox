#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolCreateInstanceIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let bridgedUrlRequest: BridgedUrlRequest
        public let bridgedCachedUrlResponse: BridgedCachedUrlResponse?
        public let bridgedUrlProtocolClientIpcObjectId: IpcObjectId
        
        public init(
            selfIpcObjectId: IpcObjectId,
            bridgedUrlRequest: BridgedUrlRequest,
            bridgedCachedUrlResponse: BridgedCachedUrlResponse?,
            bridgedUrlProtocolClientIpcObjectId: IpcObjectId)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.bridgedUrlRequest = bridgedUrlRequest
            self.bridgedCachedUrlResponse = bridgedCachedUrlResponse
            self.bridgedUrlProtocolClientIpcObjectId = bridgedUrlProtocolClientIpcObjectId
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcObjectId>
    
    public init() {
    }
}

#endif
