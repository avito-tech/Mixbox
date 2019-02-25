import Foundation
import MixboxIpc
import MixboxBuiltinIpc

// This is how to use this project:

func mainForMaster() {
    let knownPortHandshakeWaiter = KnownPortHandshakeWaiter()
    
    guard let port = knownPortHandshakeWaiter.start() else {
        exit(1)
    }
    
    launch_child_process_that_will_send_handshake_back(port)
    
    guard let client = knownPortHandshakeWaiter.waitForHandshake() else {
        exit(1)
    }
    
    use_your_client(client)
}

// This is what you should implement differently:

func launch_child_process_that_will_send_handshake_back(_ port: UInt) {
    let child = Process()
    child.launchPath = ProcessInfo.processInfo.arguments[0] // launch itself
    child.environment = ["PORT": "\(port)"]
    child.launch()
}

func use_your_client(_ client: IpcClient) {
    print("Here will be either successful response or error:\n\n")
    
    switch client.call(method: HelloIpcMethod(), arguments: IpcVoid()) {
    case .data(let string):
        print("Received: \(string)")
    case .error(let error):
        print("Error: \(error)")
    }
    print("\n\nThanks for watching.")
}
