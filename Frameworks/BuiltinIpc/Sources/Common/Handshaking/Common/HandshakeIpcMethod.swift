#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class HandshakeIpcMethod: IpcMethod {
    public typealias Arguments = UInt
    public typealias ReturnValue = Bool
    
    public init() {
    }
}

#endif
