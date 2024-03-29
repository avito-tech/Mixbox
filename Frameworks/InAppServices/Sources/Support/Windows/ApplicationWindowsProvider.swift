#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

// Should return windows as in UIApplication
public protocol ApplicationWindowsProvider {
    // as in UIApplication.windows
    var windows: [UIWindow] { get }
    
    // as in UIApplication.delegate?.window
    var applicationDelegateWindow: UIWindow? { get }
    
    // as in UIApplication.keyWindow
    var keyWindow: UIWindow? { get }
    
    // as in UIApplication.statusBarWindow() (Private API)
    var statusBarWindow: UIWindow? { get }
}

#endif
