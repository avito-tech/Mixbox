#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolCachedResponseIsValidIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolCachedResponseIsValidIpcMethod()
    
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    public init(readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>) {
        self.readableClientsRepository = readableClientsRepository
    }
    
    public func handle(
        arguments: UrlProtocolCachedResponseIsValidIpcMethod.Arguments,
        completion: @escaping (UrlProtocolCachedResponseIsValidIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let object = try readableClientsRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try object.urlProtocolCachedResponseIsValid(
                    cachedResponse: arguments.bridgedCachedUrlResponse
                )
            }
        )
    }
}

#endif
