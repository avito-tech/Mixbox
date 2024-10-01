#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

public final class KeyboardShape: PrivateClassWrapper<UIKBShape, NSObject> {
    public var frame: CGRect {
        get {
            underlyingPrivateApiObject.frame()
        }
    }
    
    public var paddedFrame: CGRect {
        get {
            underlyingPrivateApiObject.paddedFrame()
        }
    }
}

#endif
