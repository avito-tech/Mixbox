#if MIXBOX_ENABLE_IN_APP_SERVICES

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
