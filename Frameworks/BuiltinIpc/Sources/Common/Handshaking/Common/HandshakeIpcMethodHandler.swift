#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

final class HandshakeIpcMethodHandler: IpcMethodHandler {
    let method = HandshakeIpcMethod()
    var onHandshake: ((UInt) -> ())?
    
    func handle(arguments port: UInt, completion: @escaping (Bool) -> ()) {
        onHandshake?(port)
        
        completion(true)
    }
}

#endif
