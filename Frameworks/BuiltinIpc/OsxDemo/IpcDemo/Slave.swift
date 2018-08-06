import Foundation
import MixboxBuiltinIpc

func mainForSlave(_ port: UInt) {
    // This is how to use this project:
    
    let client = BuiltinIpcClient(
        host: "localhost",
        port: port
    )
    
    let server = BuiltinIpcServer()
    
    server.register(methodHandler: HelloIpcMethodHandler())
    
    if let localPort = server.start() {
        client.handshake(localPort: localPort)
    } else {
        exit(1)
    }
    
    // An imitation of running app:
    CFRunLoopRun()
}
