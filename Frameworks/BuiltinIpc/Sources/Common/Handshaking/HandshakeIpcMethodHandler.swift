import MixboxIpc

final class HandshakeIpcMethodHandler: IpcMethodHandler {
    let method = HandshakeIpcMethod()
    var onHandshake: ((UInt) -> ())?
    
    func handle(arguments port: UInt, completion: @escaping (Bool) -> ()) {
        onHandshake?(port)
        
        completion(true)
    }
}
