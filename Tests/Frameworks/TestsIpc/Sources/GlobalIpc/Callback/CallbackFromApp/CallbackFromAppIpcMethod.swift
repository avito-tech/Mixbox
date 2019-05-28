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
public final class CallbackFromAppIpcMethod<T: Codable>: IpcMethod {
    public typealias Arguments = T
    public typealias ReturnValue = IpcCallback<T, [T]>
    
    public init() {
    }
}
