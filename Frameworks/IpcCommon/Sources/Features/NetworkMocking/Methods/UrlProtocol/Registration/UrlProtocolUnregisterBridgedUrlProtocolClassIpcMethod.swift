#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc

public final class UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let bridgedUrlProtocolClassIpcObjectId: IpcObjectId
        
        public init(bridgedUrlProtocolClassIpcObjectId: IpcObjectId) {
            self.bridgedUrlProtocolClassIpcObjectId = bridgedUrlProtocolClassIpcObjectId
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
