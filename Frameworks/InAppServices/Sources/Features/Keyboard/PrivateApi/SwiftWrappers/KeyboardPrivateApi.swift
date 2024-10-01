#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import UIKit

#if SWIFT_PACKAGE
import MixboxInAppServicesObjc
#endif

public final class KeyboardPrivateApi {
    private let uiKeyboardImpl: UIKeyboardImpl
    
    public init(uiKeyboardImpl: UIKeyboardImpl) {
        self.uiKeyboardImpl = uiKeyboardImpl
    }
    
    public static func sharedInstance() throws -> KeyboardPrivateApi {
        guard let uiKeyboardImpl = UIKeyboardImpl.sharedInstance() else {
            throw ErrorString("UIKeyboardImpl.sharedInstance() is nil")
        }
        
        return KeyboardPrivateApi(
            uiKeyboardImpl: uiKeyboardImpl
        )
    }
    
    public func set(shift: Bool, autoshift: Bool) {
        uiKeyboardImpl.setShift(false, autoshift: false)
    }
    
    public func addInputString(_ inputString: String) {
        uiKeyboardImpl.addInputString(inputString)
    }
    
    public func deleteBackward() {
        uiKeyboardImpl.deleteBackward()
    }
    
    public func set(automaticMinimizationEnabled: Bool) {
        uiKeyboardImpl.setAutomaticMinimizationEnabled(automaticMinimizationEnabled)
    }
    
    public func layout() -> KeyboardLayout? {
        uiKeyboardImpl._layout().map {
            KeyboardLayout(
                underlyingPrivateApiObject: $0,
                underlyingPublicApiObject: $0
            )
        }
    }
    
    public func subtractKeyboardFrame(rect: CGRect, view: UIView) -> CGRect {
        uiKeyboardImpl.subtractKeyboardFrame(from: rect, inView: view)
    }
}

#endif
