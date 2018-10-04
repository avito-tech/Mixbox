import MixboxIpc

public protocol IpcClientHolder {
    var ipcClient: IpcClient? { get }
}

public final class IpcClientHolderImpl: IpcClientHolder {
    public weak var ipcClient: IpcClient?
    
    public init() {
    }
}
