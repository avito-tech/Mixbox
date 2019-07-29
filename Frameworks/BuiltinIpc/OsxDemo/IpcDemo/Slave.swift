import Foundation
import MixboxBuiltinIpc

func mainForSlave(_ port: UInt) {
    // This is how to use this project:
    
    let knownPortHandshakeSender = KnownPortHandshakeSender(
        handshakeWaiterHost: "localhost",
        handshakeWaiterPort: port
    )
    let (server, client) = knownPortHandshakeSender.start { server, _ in
        server.register(methodHandler: HelloIpcMethodHandler())
    }
    
    print("An imitation of usage of server and client (printing them): \(server), \(client)")
    
    // An imitation of running app:
    CFRunLoopRun()
}
