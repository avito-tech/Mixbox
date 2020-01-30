#if MIXBOX_ENABLE_IN_APP_SERVICES

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
