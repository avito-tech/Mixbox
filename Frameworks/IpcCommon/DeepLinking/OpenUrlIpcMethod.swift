import MixboxIpc

public final class OpenUrlIpcMethod: IpcMethod {
    public typealias Arguments = String // url
    public typealias ReturnValue = IpcMethodCallingResult
    
    public init() {
    }
}
