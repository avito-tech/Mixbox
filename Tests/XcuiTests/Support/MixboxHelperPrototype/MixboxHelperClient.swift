import MixboxBuiltinIpc

// Work in progess client for MixboxHelper
final class MixboxHelperClient {
    private let bonjourHandshakeWaiter = BonjourHandshakeWaiter(
        bonjourServiceSettings: BonjourServiceSettings(
            name: "MixboxTestRunner"
        )
    )
    
    func start() {
        bonjourHandshakeWaiter.start()
        
        bonjourHandshakeWaiter.onHandshake = { _ in
            print("It works!")
        }
    }
}
