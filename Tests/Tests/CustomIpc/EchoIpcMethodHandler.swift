import MixboxIpc

final class EchoIpcMethodHandler<T: Codable>: IpcMethodHandler {
    let method = EchoIpcMethod<T>()
    
    func handle(arguments: T, completion: @escaping (T) -> ()) {
        completion(arguments)
    }
}
