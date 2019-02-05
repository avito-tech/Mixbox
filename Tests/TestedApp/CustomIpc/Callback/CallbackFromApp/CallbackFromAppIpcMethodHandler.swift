import MixboxIpc
import MixboxBuiltinIpc

final class CallbackFromAppIpcMethodHandler<T: Codable>: IpcMethodHandler {
    let method = CallbackFromAppIpcMethod<T>()
    
    func handle(arguments: T, completion: @escaping (IpcCallback<T, [T]>) -> ()) {
        completion(IpcCallback<T, [T]>.async { callbackArguments, completion in
            completion([arguments, callbackArguments])
        })
    }
}
