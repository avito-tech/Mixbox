#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
