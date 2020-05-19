import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolCreateInstanceIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolCreateInstanceIpcMethod()
    
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    private let writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>
    private let ipcClient: SynchronousIpcClient
    
    public init(
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>,
        writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>,
        ipcClient: SynchronousIpcClient)
    {
        self.readableClassesRepository = readableClassesRepository
        self.writeableInstancesRepository = writeableInstancesRepository
        self.ipcClient = ipcClient
    }
    
    public func handle(
        arguments: UrlProtocolCreateInstanceIpcMethod.Arguments,
        completion: @escaping (UrlProtocolCreateInstanceIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolClass = try readableClassesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                let bridgedUrlProtocolInstance = try bridgedUrlProtocolClass.createInstance(
                    request: arguments.bridgedUrlRequest,
                    cachedResponse: arguments.bridgedCachedUrlResponse,
                    client: IpcBridgedUrlProtocolClient(
                        ipcObjectId: arguments.bridgedUrlProtocolClientIpcObjectId,
                        ipcClient: ipcClient
                    )
                )
                
                let instanceIpcObjectId = bridgedUrlProtocolInstance.ipcObjectId
                
                _ = writeableInstancesRepository.insert(
                    object: bridgedUrlProtocolInstance,
                    ipcObjectId: instanceIpcObjectId
                )
        
                return instanceIpcObjectId
            }
        )
    }
}
