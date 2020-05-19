import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolStartLoadingIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolStartLoadingIpcMethod()
    
    private let readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>
    
    public init(
        readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>)
    {
        self.readableInstancesRepository = readableInstancesRepository
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
