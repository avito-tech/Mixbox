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
public final class NestedCallbacksToAppIpcMethod: IpcMethod {
    public typealias Arguments = NestedCallbacksToAppIpcMethodArguments
    public typealias ReturnValue = IpcVoid
    
    public init() {
    }
}

public final class NestedCallbacksToAppIpcMethodArguments: Codable {
    public let sleepInterval: TimeInterval
    public let callback: IpcCallback<IpcVoid, IpcCallback<IpcVoid, IpcVoid>>
    
    public init(
        sleepInterval: TimeInterval,
        callback: IpcCallback<IpcVoid, IpcCallback<IpcVoid, IpcVoid>>)
    {
        self.sleepInterval = sleepInterval
        self.callback = callback
    }
}
