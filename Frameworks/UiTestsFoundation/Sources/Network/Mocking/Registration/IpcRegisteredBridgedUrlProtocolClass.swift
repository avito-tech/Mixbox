import MixboxIpc
import MixboxIpcCommon

public final class IpcRegisteredBridgedUrlProtocolClass: RegisteredBridgedUrlProtocolClass {
    private let ipcObjectId: IpcObjectId
    private let insertedIpcObject: InsertedIpcObject
    private let ipcClient: SynchronousIpcClient
    
    public init(
        ipcObjectId: IpcObjectId,
        insertedIpcObject: InsertedIpcObject,
        ipcClient: SynchronousIpcClient)
    {
        self.ipcObjectId = ipcObjectId
        self.insertedIpcObject = insertedIpcObject
        self.ipcClient = ipcClient
    }
    
    public func unregister() throws {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod(),
            arguments: UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod.Arguments(
                bridgedUrlProtocolClassIpcObjectId: ipcObjectId
            )
        )
        
        try result.getVoidReturnValue()
    }
}
