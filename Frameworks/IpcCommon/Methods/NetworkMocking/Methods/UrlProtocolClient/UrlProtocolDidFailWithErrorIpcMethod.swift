#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class UrlProtocolDidFailWithErrorIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let selfIpcObjectId: IpcObjectId
        public let error: String
        
        public init(
            selfIpcObjectId: IpcObjectId,
            error: String)
        {
            self.selfIpcObjectId = selfIpcObjectId
            self.error = error
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
        
    }
}

#endif
