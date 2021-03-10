import MixboxIpc
import MixboxIpcCommon

public final class IpcBridgedUrlProtocolRegisterer: BridgedUrlProtocolRegisterer {
    private let ipcClient: SynchronousIpcClient
    private let writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>
    
    public init(
        ipcClient: SynchronousIpcClient,
        writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>)
    {
        self.ipcClient = ipcClient
        self.writeableClassesRepository = writeableClassesRepository
    }
    
    public func register(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass & IpcObjectIdentifiable)
        throws
        -> RegisteredBridgedUrlProtocolClass
    {
        let result = try ipcClient.callOrThrow(
            method: UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod(),
            arguments: UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod.Arguments(
                bridgedUrlProtocolClassIpcObjectId: bridgedUrlProtocolClass.ipcObjectId
            )
        )
        
        try result.getVoidReturnValue()
        
        let insertedIpcObject = writeableClassesRepository.insert(
            object: bridgedUrlProtocolClass,
            ipcObjectId: bridgedUrlProtocolClass.ipcObjectId
        )
        
        return IpcRegisteredBridgedUrlProtocolClass(
            ipcObjectId: bridgedUrlProtocolClass.ipcObjectId,
            insertedIpcObject: insertedIpcObject,
            ipcClient: ipcClient
        )
    }
}
