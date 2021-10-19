#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

public final class UiDeviceUserInterfaceIdiomProvider: UserInterfaceIdiomProvider {
    private let uiDevice: UIDevice
    
    public init(uiDevice: UIDevice) {
        self.uiDevice = uiDevice
    }
    
    public func userInterfaceIdiom() -> UIUserInterfaceIdiom {
        return uiDevice.userInterfaceIdiom
    }
}

#endif
