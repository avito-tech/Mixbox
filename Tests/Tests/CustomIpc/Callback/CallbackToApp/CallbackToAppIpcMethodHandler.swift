import MixboxIpc

final class CallbackToAppIpcMethodHandler<T: Codable, U: Codable>: IpcMethodHandler {
    let method = CallbackToAppIpcMethod<T, U>()
    
    func handle(arguments: CallbackToAppIpcMethodArguments<T, U>, completion: @escaping (U?) -> ()) {
        arguments.callback.call(arguments: arguments.value) { result in
            completion(result.data.flatMap { $0 })
        }
    }
}
