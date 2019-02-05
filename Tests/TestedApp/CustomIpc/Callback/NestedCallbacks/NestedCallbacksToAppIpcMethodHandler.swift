import MixboxIpc

final class NestedCallbacksToAppIpcMethodHandler: IpcMethodHandler {
    let method = NestedCallbacksToAppIpcMethod()
    let queue = DispatchQueue(label: "NestedCallbacksToAppIpcMethodHandler.queue", qos: .userInteractive)
    
    func handle(arguments: NestedCallbacksToAppIpcMethodArguments, completion: @escaping (IpcVoid) -> ()) {
        queue.asyncAfter(deadline: .now() + arguments.sleepInterval) {
            arguments.callback.call { result in
                if let callback = result.data {
                    _ = callback.call()
                }
            }
        }
        
        completion(IpcVoid())
    }
}
