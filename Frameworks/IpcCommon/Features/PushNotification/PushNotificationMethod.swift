import MixboxIpc

public final class PushNotificationIpcMethod: IpcMethod {
    public typealias Arguments = String // TODO: codable dictionary
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}
