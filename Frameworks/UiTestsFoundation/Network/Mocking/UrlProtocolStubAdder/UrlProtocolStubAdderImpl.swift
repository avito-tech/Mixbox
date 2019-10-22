import MixboxFoundation
import MixboxIpcCommon
import MixboxIpc

public final class UrlProtocolStubAdderImpl: UrlProtocolStubAdder {
    // Injected:
    private let bridgedUrlProtocolRegisterer: BridgedUrlProtocolRegisterer
    private let rootBridgedUrlProtocolClass: BridgedUrlProtocolClass & IpcObjectIdentifiable
    private let bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository
    private let ipcRouterProvider: IpcRouterProvider
    private let ipcMethodHandlersRegisterer: IpcMethodHandlersRegisterer
    
    // No reason to inject this:
    private let onceToken = ThreadUnsafeOnceToken<Void>()
    
    // State:
    private var registeredBridgedUrlProtocolClass: RegisteredBridgedUrlProtocolClass?
    private var addedStubs = [AddedUrlProtocolStub]()
    
    public init(
        bridgedUrlProtocolRegisterer: BridgedUrlProtocolRegisterer,
        rootBridgedUrlProtocolClass: BridgedUrlProtocolClass & IpcObjectIdentifiable,
        bridgedUrlProtocolClassRepository: BridgedUrlProtocolClassRepository,
        ipcRouterProvider: IpcRouterProvider,
        ipcMethodHandlersRegisterer: IpcMethodHandlersRegisterer)
    {
        self.bridgedUrlProtocolRegisterer = bridgedUrlProtocolRegisterer
        self.rootBridgedUrlProtocolClass = rootBridgedUrlProtocolClass
        self.bridgedUrlProtocolClassRepository = bridgedUrlProtocolClassRepository
        self.ipcRouterProvider = ipcRouterProvider
        self.ipcMethodHandlersRegisterer = ipcMethodHandlersRegisterer
    }
    
    // TODO: Create lifecycle method and remove managing resources from deinit.
    deinit {
        try? registeredBridgedUrlProtocolClass?.unregister()
    }
    
    public func addStub(
        bridgedUrlProtocolClass: BridgedUrlProtocolClass)
        throws
        -> AddedUrlProtocolStub
    {
        try registerOnce()
        
        bridgedUrlProtocolClassRepository.add(
            bridgedUrlProtocolClass: bridgedUrlProtocolClass
        )
        
        let addedStub = ClosureAddedUrlProtocolStub(
            removeImpl: { [weak bridgedUrlProtocolClassRepository] in
                bridgedUrlProtocolClassRepository?.remove(
                    bridgedUrlProtocolClass: bridgedUrlProtocolClass
                )
            }
        )
        
        addedStubs.append(addedStub)
        
        return addedStub
    }
    
    private func registerOnce() throws {
        _ = try onceToken.executeOnce {
            try register()
        }
    }
    
    private func register() throws {
        registeredBridgedUrlProtocolClass = try bridgedUrlProtocolRegisterer.register(
            bridgedUrlProtocolClass: rootBridgedUrlProtocolClass
        )
        
        guard let ipcRouter = ipcRouterProvider.ipcRouter else {
            throw ErrorString("ipcRouter is nil")
        }
        
        ipcMethodHandlersRegisterer.registerIn(ipcRouter: ipcRouter)
    }
}
