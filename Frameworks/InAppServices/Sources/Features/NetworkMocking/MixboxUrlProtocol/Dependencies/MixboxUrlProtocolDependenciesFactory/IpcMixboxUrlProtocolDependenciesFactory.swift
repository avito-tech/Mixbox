#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxIpc
import MixboxFoundation

public final class IpcMixboxUrlProtocolDependenciesFactory: MixboxUrlProtocolDependenciesFactory, IpcMethodHandlersRegisterer {
    private let foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactory
    private let assertionFailureRecorder: AssertionFailureRecorder
    private let clientsRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolClient & IpcObjectIdentifiable>()
    private let classesRepository = IpcObjectRepositoryImpl<BridgedUrlProtocolClass & IpcObjectIdentifiable>()
    private let compoundBridgedUrlProtocolClass: CompoundBridgedUrlProtocolClass
    private let ipcMethodHandlersRegisterer: IpcMethodHandlersRegisterer
    
    public init(
        ipcClient: SynchronousIpcClient,
        foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactory,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.foundationNetworkModelsBridgingFactory = foundationNetworkModelsBridgingFactory
        self.assertionFailureRecorder = assertionFailureRecorder
        
        compoundBridgedUrlProtocolClass = CompoundBridgedUrlProtocolClass()
        
        ipcMethodHandlersRegisterer = IpcMixboxUrlProtocolIpcMethodHandlersRegisterer(
            bridgedUrlProtocolClassRepository: compoundBridgedUrlProtocolClass,
            writeableClassesRepository: classesRepository.toStorable(),
            readableClassesRepository: classesRepository.toStorable { $0 },
            writeableClientsRepository: clientsRepository.toStorable(),
            readableClientsRepository: clientsRepository.toStorable { $0 },
            ipcClient: ipcClient
        )
        
    }
    
    public func mixboxUrlProtocolClassDependencies() -> MixboxUrlProtocolDependencies {
        return MixboxUrlProtocolDependencies(
            bridgedUrlProtocolClass: compoundBridgedUrlProtocolClass,
            foundationNetworkModelsBridgingFactory: foundationNetworkModelsBridgingFactory,
            assertionFailureRecorder: assertionFailureRecorder
        )
    }
    
    public func registerIn(ipcRouter: IpcRouter) {
        ipcMethodHandlersRegisterer.registerIn(ipcRouter: ipcRouter)
    }
}

#endif
