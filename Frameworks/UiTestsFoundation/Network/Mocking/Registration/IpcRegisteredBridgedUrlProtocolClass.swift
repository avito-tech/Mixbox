import MixboxIpc
import MixboxIpcCommon

public final class IpcRegisteredBridgedUrlProtocolClass: RegisteredBridgedUrlProtocolClass {
    private let ipcObjectId: IpcObjectId
    private let insertedIpcObject: InsertedIpcObject
    private let ipcClient: IpcClient
    
    public init(
        ipcObjectId: IpcObjectId,
        insertedIpcObject: InsertedIpcObject,
        ipcClient: IpcClient)
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
