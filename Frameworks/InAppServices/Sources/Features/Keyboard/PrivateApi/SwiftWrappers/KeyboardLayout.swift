#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

public final class KeyboardLayout: PrivateClassWrapper<UIKeyboardLayout, UIView> {
    public var keyplane: KeyboardTree? {
        underlyingPrivateApiObject.keyplane().map {
            KeyboardTree(
                underlyingPrivateApiObject: $0,
                underlyingPublicApiObject: $0
            )
        }
    }
}

#endif
