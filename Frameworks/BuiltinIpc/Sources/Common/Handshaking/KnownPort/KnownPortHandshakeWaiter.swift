#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

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

#endif
