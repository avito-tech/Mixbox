import MixboxIpc

// Usage:
//
// let port = handshaker.start()
//
// launch_child_process_that_will_send_handshake_back(port)
//
// let client = handshaker.waitForHandshake()
//
// use_your_client(client)
//
public final class Handshaker {
    public let server = BuiltinIpcServer()
    private var client: IpcClient?
    private let dispatchGroup = DispatchGroup()
    
    public init() {
        dispatchGroup.enter()
        let handler = HandshakeIpcMethodHandler()
        handler.onHandshake = { [weak self, dispatchGroup] port in
            self?.client = BuiltinIpcClient(host: "localhost", port: port)
            
            dispatchGroup.leave()
        }
        server.register(methodHandler: handler)
    }
    
    public func start() -> UInt? {
        return server.start()
    }
    
    public func waitForHandshake() -> IpcClient? {
        if let client = client {
            return client
        } else {
            dispatchGroup.wait()
            return client
        }
    }
}
