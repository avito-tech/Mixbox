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
