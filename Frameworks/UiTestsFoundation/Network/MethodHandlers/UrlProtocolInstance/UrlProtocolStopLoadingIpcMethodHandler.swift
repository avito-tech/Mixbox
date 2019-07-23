import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolStopLoadingIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolStopLoadingIpcMethod()
    
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
        arguments: UrlProtocolStopLoadingIpcMethod.Arguments,
        completion: @escaping (UrlProtocolStopLoadingIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolInstance = try readableInstancesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try bridgedUrlProtocolInstance.stopLoading()
                
                return IpcVoid()
            }
        )
    }
}
