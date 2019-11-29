import MixboxIpc
import MixboxFoundation
import MixboxIpcCommon

public final class ResetUiIpcMethod<GenericArguments: Codable>: IpcMethod {
    public typealias Arguments = GenericArguments
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}
