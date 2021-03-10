#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxIpc

public final class IpcMixboxUrlProtocolIpcMethodHandlersRegisterer: IpcMethodHandlersRegisterer {
    private let bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository
    
    private let writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    
    private let writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>
    private let readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>
    
    private let ipcClient: SynchronousIpcClient
    
    public init(
        bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository,
        writeableClassesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClass & IpcObjectIdentifiable>,
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>,
        writeableClientsRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolClient & IpcObjectIdentifiable>,
        readableClientsRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClient>,
        ipcClient: SynchronousIpcClient)
    {
        self.bridgedUrlProtocolClassRepository = bridgedUrlProtocolClassRepository
        
        self.writeableClassesRepository = writeableClassesRepository
        self.readableClassesRepository = readableClassesRepository
        
        self.writeableClientsRepository = writeableClientsRepository
        self.readableClientsRepository = readableClientsRepository
        
        self.ipcClient = ipcClient
    }
    
    public func registerIn(ipcRouter: IpcRouter) {
        
        // URLProtocol: Registration
        
        ipcRouter.register(
            methodHandler: UrlProtocolRegisterBridgedUrlProtocolClassIpcMethodHandler(
                bridgedUrlProtocolClassRepository: bridgedUrlProtocolClassRepository,
                writeableClassesRepository: writeableClassesRepository,
                writeableClientsRepository: writeableClientsRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolUnregisterBridgedUrlProtocolClassIpcMethodHandler(
                bridgedUrlProtocolClassRepository: bridgedUrlProtocolClassRepository,
                readableClassesRepository: readableClassesRepository
            )
        )
        
        // URLProtocol: Client
        
        ipcRouter.register(
            methodHandler: UrlProtocolCachedResponseIsValidIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolDidFailWithErrorIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolDidFinishLoadingIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolDidLoadIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolDidReceiveIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolWasRedirectedToIpcMethodHandler(
                readableClientsRepository: readableClientsRepository
            )
        )
    }
}

#endif
