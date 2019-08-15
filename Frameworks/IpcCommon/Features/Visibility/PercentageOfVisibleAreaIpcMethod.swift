#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class PercentageOfVisibleAreaIpcMethod: IpcMethod {
    public typealias Arguments = String // view id
    public typealias ReturnValue = CGFloat?
    
    public init() {
    }
}

#endif
