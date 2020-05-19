#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol SynchronousIpcClientFactory {
    func synchronousIpcClient(ipcClient: IpcClient) -> SynchronousIpcClient
}

#endif
