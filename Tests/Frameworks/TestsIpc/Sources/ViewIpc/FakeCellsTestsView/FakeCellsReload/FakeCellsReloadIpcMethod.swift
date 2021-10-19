import MixboxIpc
import MixboxIpcCommon

public final class FakeCellsReloadIpcMethod: IpcMethod {
    public typealias Arguments = FakeCellsReloadType
    public typealias ReturnValue = IpcThrowingFunctionResult<Int> // generation, expect to get 1 after first call
    
    public init() {
    }
}
