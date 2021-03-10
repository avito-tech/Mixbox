#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolDidFailWithErrorIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolDidFailWithErrorIpcMethod()
    
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    public init(readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>) {
        self.readableClientsRepository = readableClientsRepository
    }
    
    public func handle(
        arguments: UrlProtocolDidFailWithErrorIpcMethod.Arguments,
        completion: @escaping (UrlProtocolDidFailWithErrorIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let object = try readableClientsRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try object.urlProtocolDidFailWithError(
                    error: arguments.error
                )
            }
        )
    }
}

#endif
