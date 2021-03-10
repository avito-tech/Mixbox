#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolDidReceiveIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolDidReceiveIpcMethod()
    
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    public init(readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>) {
        self.readableClientsRepository = readableClientsRepository
    }
    
    public func handle(
        arguments: UrlProtocolDidReceiveIpcMethod.Arguments,
        completion: @escaping (UrlProtocolDidReceiveIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let object = try readableClientsRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try object.urlProtocolDidReceive(
                    response: arguments.bridgedUrlResponse,
                    cacheStoragePolicy: arguments.bridgedUrlCacheStoragePolicy
                )
            }
        )
    }
}

#endif
