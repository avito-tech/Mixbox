import MixboxIpc
import MixboxBuiltinIpc

// Used for testing IpcCallback
//
// Contract:
//
// input: T (x)
// output: IpcCallback that receives T (y) and returns [x, y]
//
// So if both x and y are present in callback's completion then method worked correctly.
//
final class NestedCallbacksToAppIpcMethod: IpcMethod {
    typealias Arguments = NestedCallbacksToAppIpcMethodArguments
    typealias ReturnValue = IpcVoid
}

final class NestedCallbacksToAppIpcMethodArguments: Codable {
    let sleepInterval: TimeInterval
    let callback: IpcCallback<IpcVoid, IpcCallback<IpcVoid, IpcVoid>>
    
    init(
        sleepInterval: TimeInterval,
        callback: IpcCallback<IpcVoid, IpcCallback<IpcVoid, IpcVoid>>)
    {
        self.sleepInterval = sleepInterval
        self.callback = callback
    }
}
