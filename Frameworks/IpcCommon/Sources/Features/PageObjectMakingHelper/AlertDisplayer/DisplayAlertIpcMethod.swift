#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class DisplayAlertIpcMethod: IpcMethod {
    public typealias Arguments = Alert
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
