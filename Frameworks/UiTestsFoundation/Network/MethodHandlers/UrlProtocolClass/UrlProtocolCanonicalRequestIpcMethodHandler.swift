import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolCanonicalRequestIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolCanonicalRequestIpcMethod()
    
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
        arguments: UrlProtocolCanonicalRequestIpcMethod.Arguments,
        completion: @escaping (UrlProtocolCanonicalRequestIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolClass = try readableClassesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                return try bridgedUrlProtocolClass.canonicalRequest(
                    for: arguments.bridgedUrlRequest
                )
            }
        )
    }
}
