import MixboxIpc

public final class EchoIpcMethod<T: Codable>: IpcMethod {
    public typealias Arguments = T
    public typealias ReturnValue = T
    
    public init() {
    }
}
