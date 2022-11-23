#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

import MixboxIpc

public protocol IpcClientHolder: AnyObject {
    var ipcClient: IpcClient? { get }
}

public final class IpcClientHolderImpl: IpcClientHolder {
    public weak var ipcClient: IpcClient?
    
    public init() {
    }
}

#endif
