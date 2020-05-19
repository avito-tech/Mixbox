import MixboxIpcCommon
import MixboxIpc

public final class NetworkMockingIpcMethodsRegisterer: IpcMethodHandlersRegisterer {
    private let readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>
    private let writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>
    private let readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>
    private let ipcClient: SynchronousIpcClient
    
    public init(
        readableInstancesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolInstance>,
        writeableInstancesRepository: WriteableIpcObjectRepositoryOf<BridgedUrlProtocolInstance & IpcObjectIdentifiable>,
        readableClassesRepository: ReadableIpcObjectRepositoryOf<BridgedUrlProtocolClass>,
        ipcClient: SynchronousIpcClient)
    {
        self.readableInstancesRepository = readableInstancesRepository
        self.writeableInstancesRepository = writeableInstancesRepository
        self.readableClassesRepository = readableClassesRepository
        self.ipcClient = ipcClient
    }
    
    public func registerIn(ipcRouter: IpcRouter) {
        ipcRouter.register(
            methodHandler: UrlProtocolStartLoadingIpcMethodHandler(
                readableInstancesRepository: readableInstancesRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolStopLoadingIpcMethodHandler(
                readableInstancesRepository: readableInstancesRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolRequestIsCacheEquivalentIpcMethodHandler(
                readableClassesRepository: readableClassesRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolCanInitIpcMethodHandler(
                readableClassesRepository: readableClassesRepository
            )
        )
        
        ipcRouter.register(
            methodHandler: UrlProtocolCanonicalRequestIpcMethodHandler(
                readableClassesRepository: readableClassesRepository
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
