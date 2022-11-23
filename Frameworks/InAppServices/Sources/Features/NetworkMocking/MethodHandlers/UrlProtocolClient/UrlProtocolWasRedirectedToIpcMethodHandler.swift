#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
