#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

import MixboxIpc

// Usage:
//
// // precondition: process is launched with host & port
//
// let knownPortHandshakeSender = KnownPortHandshakeSender(handshakeWaiterHost: host, handshakeWaiterPort: port)
// let (server, client) = knownPortHandshakeSender.start { server in
//     router.register(methodHandler: MyCoolIpcMethodHandler()) // anything you want
// }
//
public final class KnownPortHandshakeSender {
    private let handshakeWaiterHost: String
    private let handshakeWaiterPort: UInt
    private let handshakeTools: HandshakeTools
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    
    public init(
        handshakeWaiterHost: String,
        handshakeWaiterPort: UInt,
        synchronousIpcClientFactory: SynchronousIpcClientFactory)
    {
        self.handshakeWaiterHost = handshakeWaiterHost
        self.handshakeWaiterPort = handshakeWaiterPort
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
        
        handshakeTools = HandshakeTools()
    }
    
    public func start(
        beforeHandshake: (IpcRouter, IpcClient) throws -> ())
        rethrows
        -> (IpcRouter, IpcClient)
    {
        let client = handshakeTools.makeClient(
            host: handshakeWaiterHost,
            port: handshakeWaiterPort
        )
        
        if let localPort = handshakeTools.startServer() {
            try beforeHandshake(handshakeTools.server, client)
            
            let synchronousIpcClient = synchronousIpcClientFactory.synchronousIpcClient(ipcClient: client)
            
            // TODO: Check if we can deal with synchronous waiting when this class is used to
            // setup connections between iOS app and UI tests runner. Maybe if we really want generic solution
            // we have to add parameter that controls whether to wait synchronously or not.
            // TODO: Handle result.
            _ = synchronousIpcClient.call(
                method: HandshakeIpcMethod(),
                arguments: localPort
            )
        }
        
        return (handshakeTools.server, client)
    }
}

#endif
