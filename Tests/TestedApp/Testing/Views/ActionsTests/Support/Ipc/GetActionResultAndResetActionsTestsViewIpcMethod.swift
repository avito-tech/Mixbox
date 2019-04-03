import MixboxIpc
import MixboxFoundation

public final class GetActionResultIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = String?
    
    public init() {
    }
}

public final class ResetActionResultIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = ErrorString?
    
    public init() {
    }
}
