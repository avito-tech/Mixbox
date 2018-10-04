import MixboxIpc

public class CallIpcCallbackIpcMethod: IpcMethod {
    public typealias Arguments = CallIpcCallbackIpcMethodArguments
    public typealias ReturnValue = String?
}

public final class CallIpcCallbackIpcMethodArguments: Codable {
    public let callbackId: String
    public let callbackArguments: String
    
    public init(
        callbackId: String,
        callbackArguments: String)
    {
        self.callbackId = callbackId
        self.callbackArguments = callbackArguments
    }
}
