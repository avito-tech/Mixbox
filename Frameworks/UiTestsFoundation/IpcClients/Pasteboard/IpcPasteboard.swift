import MixboxIpc
import MixboxIpcCommon

// If UikitPasteboard is used, pasteboard is shared between tests and tested app.
// However, it is not synchronous. IpcClient can make synchronous calls.
public final class IpcPasteboard: Pasteboard {
    private let ipcClient: SynchronousIpcClient
    
    public init(ipcClient: SynchronousIpcClient) {
        self.ipcClient = ipcClient
    }
    
    public func setString(_ string: String?) throws {
        try ipcClient.callOrThrow(method: SetPasteboardStringIpcMethod(), arguments: string)
    }
    
    public func getString() throws -> String? {
        return try ipcClient.callOrThrow(method: GetPasteboardStringIpcMethod())
    }
}
