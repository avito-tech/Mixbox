#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxBuiltinIpcObjc
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
    
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> StartedIpc {
        let (router, client) = try knownPortHandshakeSender.start(
            beforeHandshake: { ipcRouter, ipcClient in
                let dependencies = IpcMethodHandlerRegistrationDependencies(
                    ipcRouter: ipcRouter,
                    ipcClient: ipcClient,
                    synchronousIpcClient: synchronousIpcClientFactory.synchronousIpcClient(ipcClient: ipcClient)
                )
                
                try commandsForAddingRoutes.forEach { command in
                    try command(dependencies)
                }
            }
        )
        
        return StartedIpc(
            ipcRouter: router,
            ipcClient: client
        )
    }
}

#endif
