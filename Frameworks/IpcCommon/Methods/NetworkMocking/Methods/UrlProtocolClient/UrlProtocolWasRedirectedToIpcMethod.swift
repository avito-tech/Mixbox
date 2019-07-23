#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolWasRedirectedToIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let bridgedUrlRequest: BridgedUrlRequest
        public let redirectBridgedUrlResponse: BridgedUrlResponse
        
        public init(
            selfIpcObjectId: IpcObjectId,
            bridgedUrlRequest: BridgedUrlRequest,
            redirectBridgedUrlResponse: BridgedUrlResponse)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.bridgedUrlRequest = bridgedUrlRequest
            self.redirectBridgedUrlResponse = redirectBridgedUrlResponse
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
