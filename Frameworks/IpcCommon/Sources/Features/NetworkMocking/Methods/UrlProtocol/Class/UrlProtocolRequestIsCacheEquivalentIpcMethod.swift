#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
