#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class ScrollingHintIpcMethod: IpcMethod {
    public typealias Arguments = String
    public typealias ReturnValue = ScrollingHint
    
    public init() {
    }
}

#endif
