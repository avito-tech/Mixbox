#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class GetPasteboardStringIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = String?
    
    public init() {
    }
}

#endif
