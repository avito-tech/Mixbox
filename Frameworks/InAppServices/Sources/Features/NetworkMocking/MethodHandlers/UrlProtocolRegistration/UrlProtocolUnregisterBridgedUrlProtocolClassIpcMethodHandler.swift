#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
