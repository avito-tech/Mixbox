import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolCanInitIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolCanInitIpcMethod()
    
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    
    public init(
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>)
    {
        self.readableClassesRepository = readableClassesRepository
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
