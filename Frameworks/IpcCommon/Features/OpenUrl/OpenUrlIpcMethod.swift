#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class OpenUrlIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let url: URL
        
        public init(url: URL) {
            self.url = url
        }
    }
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
