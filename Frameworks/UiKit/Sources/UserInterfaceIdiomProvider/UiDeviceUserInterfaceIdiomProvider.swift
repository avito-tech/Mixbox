#if MIXBOX_ENABLE_FRAMEWORK_UI_KIT && MIXBOX_DISABLE_FRAMEWORK_UI_KIT
#error("UiKit is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_UI_KIT || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_UI_KIT)
// The compilation is disabled
#else

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
