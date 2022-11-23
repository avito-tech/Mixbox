#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxIpcCommon

public final class UrlProtocolRegisterBridgedUrlProtocolClassIpcMethodHandler: IpcMethodHandler {
    public let method = UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod()
    
    private let bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository
    private let writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>
    private let writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>
    private let ipcClient: SynchronousIpcClient
    
    public init(
        bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository,
        writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>,
        writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>,
        ipcClient: SynchronousIpcClient)
    {
        self.bridgedUrlProtocolClassRepository = bridgedUrlProtocolClassRepository
        self.writeableClassesRepository = writeableClassesRepository
        self.writeableClientsRepository = writeableClientsRepository
        self.ipcClient = ipcClient
    }
    
    public func handle(
        arguments: UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod.Arguments,
        completion: @escaping (UrlProtocolRegisterBridgedUrlProtocolClassIpcMethod.ReturnValue) -> ())
    {
        let bridgedUrlProtocolClass = IpcBridgedUrlProtocolClass(
            ipcObjectId: arguments.bridgedUrlProtocolClassIpcObjectId,
            ipcClient: ipcClient,
            writeableClientsRepository: writeableClientsRepository
        )
        
        bridgedUrlProtocolClassRepository.add(
            bridgedUrlProtocolClass: bridgedUrlProtocolClass
        )
        
        // TODO: use `addedObject`
        _ = writeableClassesRepository.insert(
            object: bridgedUrlProtocolClass,
            ipcObjectId: bridgedUrlProtocolClass.ipcObjectId
        )
        
        completion(
            IpcThrowingFunctionResult {
                IpcVoid()
            }
        )
    }
}

#endif
