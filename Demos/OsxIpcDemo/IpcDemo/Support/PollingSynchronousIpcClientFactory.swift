import MixboxIpc

public final class PollingSynchronousIpcClientFactory: SynchronousIpcClientFactory {
    public init() {
    }
    
    public func synchronousIpcClient(ipcClient: IpcClient) -> SynchronousIpcClient {
        return PollingSynchronousIpcClient(ipcClient: ipcClient)
    }
}
