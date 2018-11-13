import MixboxIpc

// Usage:
//
// let port = knownPortHandshakeWaiter.start()
//
// launch_child_process_that_will_send_handshake_back(port)
//
// let client = knownPortHandshakeWaiter.waitForHandshake()
//
// use_your_client(client)
//
public final class KnownPortHandshakeWaiter {
    private let handshakeTools = HandshakeTools()
    
    public var server: BuiltinIpcServer {
        return handshakeTools.server
    }
    
    public init() {
        handshakeTools.setUpHandshakeIpcMethodHandler()
    }
    
    public func start() -> UInt? {
        return handshakeTools.startServer()
    }
    
    public func waitForHandshake() -> IpcClient? {
        return handshakeTools.waitForHandshake()
    }
}
