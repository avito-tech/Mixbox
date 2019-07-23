import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolCanInitIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolCanInitIpcMethod()
    
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    private let ipcClient: IpcClient
    
    public init(
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>,
        ipcClient: IpcClient)
    {
        self.readableClassesRepository = readableClassesRepository
        self.ipcClient = ipcClient
    }
    
    public func handle(
        arguments: UrlProtocolCanInitIpcMethod.Arguments,
        completion: @escaping (UrlProtocolCanInitIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolClass = try readableClassesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                return try bridgedUrlProtocolClass.canInit(
                    with: arguments.bridgedUrlRequest
                )
            }
        )
    }
}
