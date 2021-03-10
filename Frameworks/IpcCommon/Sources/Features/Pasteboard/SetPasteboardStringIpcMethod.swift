#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class SetPasteboardStringIpcMethod: IpcMethod {
    public typealias Arguments = String?
    public typealias ReturnValue = IpcVoid
    
    public init() {
    }
}

#endif
