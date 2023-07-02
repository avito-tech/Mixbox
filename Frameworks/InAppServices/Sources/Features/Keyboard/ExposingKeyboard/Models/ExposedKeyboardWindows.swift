#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit

public final class ExposedKeyboardWindows {
    public let windowWithDrawableKeyboard: UIView // keyboard is drawable, but accessory views are not
    public let windowWithDrawableAccessoryViews: UIWindow // accessory views are drawable, but keyboard is not
    public let patchedWindows: [UIWindow]
    
    public init(
        windowWithDrawableKeyboard: UIView,
        windowWithDrawableAccessoryViews: UIWindow,
        patchedWindows: [UIWindow]
    ) {
        self.windowWithDrawableKeyboard = windowWithDrawableKeyboard
        self.windowWithDrawableAccessoryViews = windowWithDrawableAccessoryViews
        self.patchedWindows = patchedWindows
    }
}

#endif
