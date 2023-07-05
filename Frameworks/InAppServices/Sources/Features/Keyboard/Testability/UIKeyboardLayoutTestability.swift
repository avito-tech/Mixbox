#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation

@objc(UIKeyboardLayoutTestability)
final class UIKeyboardLayoutTestability: NSObject {
    private let keyboardLayout: KeyboardLayout
    
    @objc init(underlyingObject: UIKeyboardLayout) {
        self.keyboardLayout = KeyboardLayout(
            underlyingPrivateApiObject: underlyingObject,
            underlyingPublicApiObject: underlyingObject
        )
    }
    
    @objc override func mb_testability_children() -> [TestabilityElement] {
        handleErrorInTestabilityElementMethod(
            body: {
                let keys = try keyboardLayout.keyplane.unwrapOrThrow().keys
                return keys.map { $0.underlyingObject }
            },
            defaultValue: {
                return []
            }
        )
    }

    @objc override func mb_testability_elementType() -> TestabilityElementType {
        .keyboard
    }
}

#endif
