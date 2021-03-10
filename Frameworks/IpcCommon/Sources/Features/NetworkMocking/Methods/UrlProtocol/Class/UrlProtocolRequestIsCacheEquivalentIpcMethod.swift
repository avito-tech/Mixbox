#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolRequestIsCacheEquivalentIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let lhsRequest: BridgedUrlRequest
        public let rhsRequest: BridgedUrlRequest
        
        public init(
            selfIpcObjectId: IpcObjectId,
            lhsRequest: BridgedUrlRequest,
            rhsRequest: BridgedUrlRequest)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.lhsRequest = lhsRequest
            self.rhsRequest = rhsRequest
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<Bool>
    
    public init() {
    }
}

#endif
