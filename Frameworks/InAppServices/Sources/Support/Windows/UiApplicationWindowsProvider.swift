#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxUiKit

public final class UiApplicationWindowsProvider: ApplicationWindowsProvider {
    private let uiApplication: UIApplication
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        uiApplication: UIApplication,
        iosVersionProvider: IosVersionProvider)
    {
        self.uiApplication = uiApplication
        self.iosVersionProvider = iosVersionProvider
    }
    
    public var windows: [UIWindow] {
        return uiApplication.windows
    }
    
    public var applicationDelegateWindow: UIWindow? {
        return uiApplication.delegate?.window ?? nil
    }
    
    public var keyWindow: UIWindow? {
        return uiApplication.keyWindow
    }
    
    public var statusBarWindow: UIWindow? {
        return iosVersionProvider.iosVersion().majorVersion < 13
            ? uiApplication.statusBarWindow()
            : nil
    }
}

#endif
