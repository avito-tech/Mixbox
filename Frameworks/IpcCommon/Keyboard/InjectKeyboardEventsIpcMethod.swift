import MixboxIpc

public final class InjectKeyboardEventsIpcMethod: IpcMethod {
    public typealias Arguments = [KeyboardEvent]
    public typealias ReturnValue = IpcVoid
    
    public init() {
    }
}
