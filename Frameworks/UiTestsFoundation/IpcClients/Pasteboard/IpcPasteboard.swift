import MixboxIpc
import MixboxIpcCommon

// If UikitPasteboard is used, pasteboard is shared between tests and tested app.
// However, it is not synchronous. IpcClient can make synchronous calls.
public final class IpcPasteboard: Pasteboard {
    private let ipcClient: IpcClient
    
    public init(ipcClient: IpcClient) {
        self.ipcClient = ipcClient
    }
    
    public var string: String? {
        get {
            return ipcClient.call(method: GetPasteboardStringIpcMethod()).data ?? nil
        }
        set {
            _ = ipcClient.call(method: SetPasteboardStringIpcMethod(), arguments: newValue)
        }
    }
}
