#if MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC && MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC
#error("BuiltinIpc is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_BUILTIN_IPC || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_BUILTIN_IPC)
// The compilation is disabled
#else

import MixboxIpc

public class CallIpcCallbackIpcMethodHandler: IpcMethodHandler {
    public let method = CallIpcCallbackIpcMethod()
    private let ipcCallbackStorage: IpcCallbackStorage
    
    public init(ipcCallbackStorage: IpcCallbackStorage) {
        self.ipcCallbackStorage = ipcCallbackStorage
    }
    
    public func handle(arguments: CallIpcCallbackIpcMethod.Arguments, completion: @escaping (String?) -> ()) {
        guard let closure = ipcCallbackStorage[arguments.callbackId] else {
            return completion(nil)
        }
        
        closure(arguments.callbackArguments) {
            completion($0)
        }
    }
}

#endif
