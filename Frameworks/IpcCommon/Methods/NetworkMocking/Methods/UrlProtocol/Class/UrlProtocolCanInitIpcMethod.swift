#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolCanInitIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let bridgedUrlRequest: BridgedUrlRequest
        
        public init(
            selfIpcObjectId: IpcObjectId,
            bridgedUrlRequest: BridgedUrlRequest)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.bridgedUrlRequest = bridgedUrlRequest
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<Bool>
    
    public init() {
    }
}

#endif
