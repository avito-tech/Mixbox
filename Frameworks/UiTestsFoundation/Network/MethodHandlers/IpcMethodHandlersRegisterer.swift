import MixboxIpcCommon
import MixboxIpc

public final class NetworkMockingIpcMethodsRegisterer: IpcMethodHandlersRegisterer {
    private let readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>
    private let writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    private let ipcClient: IpcClient
    
    public init(
        readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>,
        writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>,
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>,
        ipcClient: IpcClient)
    {
        self.readableInstancesRepository = readableInstancesRepository
        self.writeableInstancesRepository = writeableInstancesRepository
        self.readableClassesRepository = readableClassesRepository
        self.ipcClient = ipcClient
    }
    
    public func registerIn(ipcRouter: IpcRouter) {
        ipcRouter.register(
            methodHandler: UrlProtocolStartLoadingIpcMethodHandler(
                readableInstancesRepository: readableInstancesRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolStopLoadingIpcMethodHandler(
                readableInstancesRepository: readableInstancesRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolRequestIsCacheEquivalentIpcMethodHandler(
                readableClassesRepository: readableClassesRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolCanInitIpcMethodHandler(
                readableClassesRepository: readableClassesRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolCanonicalRequestIpcMethodHandler(
                readableClassesRepository: readableClassesRepository,
                ipcClient: ipcClient
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolCreateInstanceIpcMethodHandler(
                readableClassesRepository: readableClassesRepository,
                writeableInstancesRepository: writeableInstancesRepository,
                ipcClient: ipcClient
            )
        )
    }
}
