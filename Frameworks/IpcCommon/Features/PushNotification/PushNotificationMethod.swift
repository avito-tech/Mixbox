#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class PushNotificationIpcMethod: IpcMethod {
    public typealias Arguments = String // TODO: codable dictionary
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
