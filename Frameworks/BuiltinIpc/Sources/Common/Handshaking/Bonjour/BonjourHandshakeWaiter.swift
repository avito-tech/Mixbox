#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

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
