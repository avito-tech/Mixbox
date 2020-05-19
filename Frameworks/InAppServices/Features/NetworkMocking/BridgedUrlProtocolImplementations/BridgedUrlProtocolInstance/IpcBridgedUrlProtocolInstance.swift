#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

// The only responsibility of this class is to access `BridgedUrlProtocolInstance` via IPC.
public final class IpcBridgedUrlProtocolInstance: BridgedUrlProtocolInstance, IpcObjectIdentifiable {
    public let ipcObjectId: IpcObjectId
    
    private let ipcClient: SynchronousIpcClient
    
    public init(
        ipcObjectId: IpcObjectId,
        ipcClient: SynchronousIpcClient)
    {
        self.ipcObjectId = ipcObjectId
        self.ipcClient = ipcClient
    }
    
    public func startLoading() throws {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolStartLoadingIpcMethod(),
            arguments: UrlProtocolStartLoadingIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId
            )
        )
        
        try result.getVoidReturnValue()
    }
    
    public func stopLoading() throws {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolStopLoadingIpcMethod(),
            arguments: UrlProtocolStopLoadingIpcMethod.Arguments(
                selfIpcObjectId: ipcObjectId
            )
        )
        
        try result.getVoidReturnValue()
    }
}

#endif
