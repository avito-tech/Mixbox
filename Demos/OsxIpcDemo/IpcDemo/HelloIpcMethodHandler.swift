#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

final class HelloIpcMethodHandler: IpcMethodHandler {
    let method = HelloIpcMethod()
    
    func handle(arguments: IpcVoid, completion: @escaping (String) -> ()) {
        completion("Hello, world!")
    }
}

#endif
