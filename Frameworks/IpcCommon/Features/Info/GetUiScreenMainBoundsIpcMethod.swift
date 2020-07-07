#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class GetUiScreenMainBoundsIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = CGRect
    
    public init() {
    }
}

#endif
