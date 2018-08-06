import Foundation
import MixboxIpc
import MixboxBuiltinIpc

// This is how to use this project:

func mainForMaster() {
    let handshaker = Handshaker()
    
    guard let port = handshaker.start() else {
        print("Failed to start the server.")
        exit(1)
    }
    
    launchYourApp(port)
    
    guard let client = handshaker.waitForHandshake() else {
        print("Failed to handshake.")
        exit(1)
    }
    
    communicateWithYourApp(client)
}

// This is what you should implement differently:

func launchYourApp(_ port: UInt) {
    let child = Process()
    child.launchPath = ProcessInfo.processInfo.arguments[0] // launch itself
    child.environment = ["PORT": "\(port)"]
    child.launch()
}

func communicateWithYourApp(_ client: IpcClient) {
    print("Here will be either successful response or error:\n\n")
    
    switch client.call(method: HelloIpcMethod(), arguments: IpcVoid()) {
    case .data(let string):
        print("Received: \(string)")
    case .error(let error):
        print("Error: \(error)")
    }
    print("\n\nThanks for watching.")
}
