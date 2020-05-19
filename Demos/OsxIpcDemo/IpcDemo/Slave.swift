import Foundation
import MixboxBuiltinIpc

func mainForSlave(_ port: UInt) {
    // This is how to use this project:
    
    let knownPortHandshakeSender = KnownPortHandshakeSender(
        handshakeWaiterHost: "localhost",
        handshakeWaiterPort: port,
        synchronousIpcClientFactory: PollingSynchronousIpcClientFactory()
    )
    let (server, client) = knownPortHandshakeSender.start { server, _ in
        server.register(methodHandler: HelloIpcMethodHandler())
    }
    
    print("Child process connected to parent: \(server), \(client)")
    
    // An imitation of running app:
    CFRunLoopRun()
}
