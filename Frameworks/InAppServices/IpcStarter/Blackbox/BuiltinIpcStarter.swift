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
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) throws -> (IpcRouter, IpcClient?) {
        return knownPortHandshakeSender.start(
            beforeHandshake: { router in
                commandsForAddingRoutes.forEach { $0(router) }
            }
        )
    }
}

#endif
