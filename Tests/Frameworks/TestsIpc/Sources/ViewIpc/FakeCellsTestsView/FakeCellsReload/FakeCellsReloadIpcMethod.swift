import MixboxIpc

public final class FakeCellsReloadIpcMethod: IpcMethod {
    public typealias Arguments = FakeCellsReloadType
    public typealias ReturnValue = Int // generation, expect to get 1 after first call
    
    public init() {
    }
}
