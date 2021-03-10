#if MIXBOX_ENABLE_IN_APP_SERVICES

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
