#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import MixboxIpc
import UIKit

// Apple's UI test runner app can have different screen settings than tested app
// so if you want to get screen settings of app, use this method
public final class GetUiScreenMainBoundsIpcMethod: IpcMethod {
    public typealias Arguments = IpcVoid
    public typealias ReturnValue = CGRect
    
    public init() {
    }
}

#endif
