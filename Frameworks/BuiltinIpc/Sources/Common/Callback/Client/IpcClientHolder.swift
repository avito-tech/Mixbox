#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public protocol IpcClientHolder: class {
    var ipcClient: IpcClient? { get }
}

public final class IpcClientHolderImpl: IpcClientHolder {
    public weak var ipcClient: IpcClient?
    
    public init() {
    }
}

#endif
