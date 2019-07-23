import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolStartLoadingIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolStartLoadingIpcMethod()
    
    private let readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>
    private let ipcClient: IpcClient
    
    public init(
        readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>,
        ipcClient: IpcClient)
    {
        self.readableInstancesRepository = readableInstancesRepository
        self.ipcClient = ipcClient
    }
    
    public func handle(
        arguments: UrlProtocolStartLoadingIpcMethod.Arguments,
        completion: @escaping (UrlProtocolStartLoadingIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolInstance = try readableInstancesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try bridgedUrlProtocolInstance.startLoading()
                
                return IpcVoid()
            }
        )
    }
}
