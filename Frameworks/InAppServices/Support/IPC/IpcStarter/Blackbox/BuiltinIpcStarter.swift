#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxBuiltinIpc

final class BuiltinIpcStarter: IpcStarter {
    private let knownPortHandshakeSender: KnownPortHandshakeSender
    
    init(
        testRunnerHost: String,
        testRunnerPort: UInt)
    {
        self.knownPortHandshakeSender = KnownPortHandshakeSender(
            handshakeWaiterHost: testRunnerHost,
            handshakeWaiterPort: testRunnerPort
        )
    }
    
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> (IpcRouter, IpcClient?) {
        let (router, client) = knownPortHandshakeSender.start(
            beforeHandshake: { ipcRouter, ipcClient in
                let dependencies = IpcMethodHandlerRegistrationDependencies(
                    ipcRouter: ipcRouter,
                    ipcClient: ipcClient
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
