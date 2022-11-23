#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
