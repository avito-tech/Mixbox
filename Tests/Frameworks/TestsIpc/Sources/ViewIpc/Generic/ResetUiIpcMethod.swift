import MixboxIpc
import MixboxFoundation
import MixboxIpcCommon

public final class ResetUiIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}
