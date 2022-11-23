#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

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
