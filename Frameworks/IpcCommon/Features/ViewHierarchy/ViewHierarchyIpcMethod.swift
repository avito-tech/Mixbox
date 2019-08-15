#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class ViewHierarchyIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = ViewHierarchy
    
    public init() {
    }
}

#endif
