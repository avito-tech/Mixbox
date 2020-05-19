import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolRequestIsCacheEquivalentIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolRequestIsCacheEquivalentIpcMethod()
    
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    
    public init(
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>)
    {
        self.readableClassesRepository = readableClassesRepository
    }
    
    public func handle(
        arguments: UrlProtocolRequestIsCacheEquivalentIpcMethod.Arguments,
        completion: @escaping (UrlProtocolRequestIsCacheEquivalentIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult {
                let bridgedUrlProtocolClass = try readableClassesRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                return try bridgedUrlProtocolClass.requestIsCacheEquivalent(
                    arguments.lhsRequest,
                    to: arguments.rhsRequest
                )
            }
        )
    }
}
