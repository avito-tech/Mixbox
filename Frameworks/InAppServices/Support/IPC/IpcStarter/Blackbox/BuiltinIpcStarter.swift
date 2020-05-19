#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxBuiltinIpc

final class BuiltinIpcStarter: IpcStarter {
    private let knownPortHandshakeSender: KnownPortHandshakeSender
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    
    init(
        testRunnerHost: String,
        testRunnerPort: UInt,
        synchronousIpcClientFactory: SynchronousIpcClientFactory)
    {
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
        
        self.knownPortHandshakeSender = KnownPortHandshakeSender(
            handshakeWaiterHost: testRunnerHost,
            handshakeWaiterPort: testRunnerPort,
            synchronousIpcClientFactory: synchronousIpcClientFactory
        )
    }
    
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> (IpcRouter, IpcClient?) {
        let (router, client) = knownPortHandshakeSender.start(
            beforeHandshake: { ipcRouter, ipcClient in
                let dependencies = IpcMethodHandlerRegistrationDependencies(
                    ipcRouter: ipcRouter,
                    ipcClient: ipcClient,
                    synchronousIpcClient: synchronousIpcClientFactory.synchronousIpcClient(ipcClient: ipcClient)
                )
                
                commandsForAddingRoutes.forEach { command in
                    command(dependencies)
                }
            }
        )
        
        return (router, client)
    }
}

#endif
