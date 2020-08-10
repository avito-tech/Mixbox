#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod()
    
    private let bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    
    public init(
        bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository,
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>)
    {
        self.bridgedUrlProtocolClassRepository = bridgedUrlProtocolClassRepository
        self.readableClassesRepository = readableClassesRepository
    }
    
    public func handle(
        arguments: UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod.Arguments,
        completion: @escaping (UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                let classIpcObjectId = arguments.bridgedUrlProtocolClassIpcObjectId
                
                let bridgedUrlProtocolClass = try readableClassesRepository.objectOrThrow(
                    ipcObjectId: classIpcObjectId
                )
                
                bridgedUrlProtocolClassRepository.remove(
                    bridgedUrlProtocolClass: bridgedUrlProtocolClass
                )
            }
        )
    }
}

#endif
