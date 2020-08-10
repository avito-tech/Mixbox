#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolWasRedirectedToIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolWasRedirectedToIpcMethod()
    
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    public init(readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>) {
        self.readableClientsRepository = readableClientsRepository
    }
    
    public func handle(
        arguments: UrlProtocolWasRedirectedToIpcMethod.Arguments,
        completion: @escaping (UrlProtocolWasRedirectedToIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let object = try readableClientsRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try object.urlProtocolWasRedirectedTo(
                    request: arguments.bridgedUrlRequest,
                    redirectResponse: arguments.redirectBridgedUrlResponse
                )
            }
        )
    }
}

#endif
