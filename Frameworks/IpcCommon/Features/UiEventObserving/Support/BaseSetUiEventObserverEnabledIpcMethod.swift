#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import MixboxFoundation

// Base class for implementing toggling of custom ` UiEventObserver`'s
open class BaseSetUiEventObserverEnabledIpcMethod: IpcMethod {
    public typealias Arguments = Bool
    public typealias ReturnValue = IpcThrowingFunctionResult<IpcVoid>
    
    public init() {
    }
}

#endif
