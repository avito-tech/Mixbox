#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod: IpcMethod {
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
