#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolDidFinishLoadingIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolDidFinishLoadingIpcMethod()
    
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    public init(readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>) {
        self.readableClientsRepository = readableClientsRepository
    }
    
    public func handle(
        arguments: UrlProtocolDidFinishLoadingIpcMethod.Arguments,
        completion: @escaping (UrlProtocolDidFinishLoadingIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let object = try readableClientsRepository.objectOrThrow(
                    ipcObjectId: arguments.selfIpcObjectId
                )
                
                try object.urlProtocolDidFinishLoading()
            }
        )
    }
}

#endif
