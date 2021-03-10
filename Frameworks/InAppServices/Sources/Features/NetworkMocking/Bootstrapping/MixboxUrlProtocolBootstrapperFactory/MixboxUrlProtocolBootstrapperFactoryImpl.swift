#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

public final class MixboxUrlProtocolBootstrapperFactoryImpl: MixboxUrlProtocolBootstrapperFactory {
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    private let ipcStarterTypeProvider: IpcStarterTypeProvider
    private let assertingSwizzler: AssertingSwizzler
    private let assertionFailureRecorder: AssertionFailureRecorder
    
    public init(
        synchronousIpcClientFactory: SynchronousIpcClientFactory,
        ipcStarterTypeProvider: IpcStarterTypeProvider,
        assertingSwizzler: AssertingSwizzler,
        assertionFailureRecorder: AssertionFailureRecorder)
    {
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
        self.ipcStarterTypeProvider = ipcStarterTypeProvider
        self.assertingSwizzler = assertingSwizzler
        self.assertionFailureRecorder = assertionFailureRecorder
    }
    
    public func mixboxUrlProtocolBootstrapper(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient)
        throws
        -> MixboxUrlProtocolBootstrapper?
    {
        let synchronousIpcClient = synchronousIpcClientFactory.synchronousIpcClient(
            ipcClient: ipcClient
        )
        
        let ipcMixboxUrlProtocolDependenciesFactory = try self.ipcMixboxUrlProtocolDependenciesFactory(
            synchronousIpcClient: synchronousIpcClient
        )
        
        return ipcMixboxUrlProtocolDependenciesFactory.map { ipcMixboxUrlProtocolDependenciesFactory in
            MixboxUrlProtocolBootstrapperImpl(
                assertingSwizzler: assertingSwizzler,
                mixboxUrlProtocolDependenciesFactory: ipcMixboxUrlProtocolDependenciesFactory,
                mixboxUrlProtocolSpecificIpcMethodHandlersRegisterer: ipcMixboxUrlProtocolDependenciesFactory,
                ipcRouter: ipcRouter
            )
        }
    }
    
    private func ipcMixboxUrlProtocolDependenciesFactory(
        synchronousIpcClient: SynchronousIpcClient)
        throws
        -> IpcMixboxUrlProtocolDependenciesFactory?
    {
        switch try networkMockingBootstrappingType() {
        case .disabled:
            return nil
        case .inProcess:
            // In-process URLProtocol is currently implemented via fake IPC (see `SameProcessIpcClientServer`).
            //
            // Usage of fake IpcClient (IPC without "IP") adds some little overhead, but no additional code is needed.
            // My attempt to implement solution with no overhead wasn't successful, because it required substantial time
            // investments at the moment I was implementing this feature.
            //
            return IpcMixboxUrlProtocolDependenciesFactory(
                ipcClient: synchronousIpcClient,
                foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactoryImpl(),
                assertionFailureRecorder: assertionFailureRecorder
            )
        case .ipc:
            return IpcMixboxUrlProtocolDependenciesFactory(
                ipcClient: synchronousIpcClient,
                foundationNetworkModelsBridgingFactory: FoundationNetworkModelsBridgingFactoryImpl(),
                assertionFailureRecorder: assertionFailureRecorder
            )
        }
    }
    
    private func networkMockingBootstrappingType() throws -> NetworkMockingBootstrappingType {
        switch try ipcStarterTypeProvider.ipcStarterType() {
        case .blackbox:
            return .ipc
        case .sbtui:
            return .disabled
        case .graybox:
            return .inProcess
        }
    }
}

#endif
