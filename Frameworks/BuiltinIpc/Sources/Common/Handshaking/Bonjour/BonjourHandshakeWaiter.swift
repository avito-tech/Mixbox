#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

// Usage:
//
// bonjourHandshakeWaiter.start()
// bonjourHandshakeWaiter.onHandshake = { _ in
//     print("It works!")
// }
//
public final class BonjourHandshakeWaiter {
    private let handshakeTools: HandshakeTools
    
    public var server: BuiltinIpcServer {
        return handshakeTools.server
    }
    
    public init(bonjourServiceSettings: BonjourServiceSettings) {
        handshakeTools = HandshakeTools(
            bonjourServiceSettings: bonjourServiceSettings
        )
        handshakeTools.setUpHandshakeIpcMethodHandler()
    }
    
    public var onHandshake: ((IpcClient?) -> ())? {
        get { return handshakeTools.onHandshake }
        set { handshakeTools.onHandshake = newValue }
    }
    
    public func start() {
        handshakeTools.startServer()
    }
}

#endif
