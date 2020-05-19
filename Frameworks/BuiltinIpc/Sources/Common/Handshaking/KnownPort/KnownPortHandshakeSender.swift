#if MIXBOX_ENABLE_IN_APP_SERVICES

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
    
    public func start(beforeHandshake: (IpcRouter, IpcClient) -> ()) -> (IpcRouter, IpcClient) {
        let client = handshakeTools.makeClient(
            host: handshakeWaiterHost,
            port: handshakeWaiterPort
        )
        
        if let localPort = handshakeTools.startServer() {
            beforeHandshake(handshakeTools.server, client)
            
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
