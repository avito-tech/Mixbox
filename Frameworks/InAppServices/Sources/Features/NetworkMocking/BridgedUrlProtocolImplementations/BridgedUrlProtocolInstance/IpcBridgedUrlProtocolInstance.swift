#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
