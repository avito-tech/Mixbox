#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxUiKit

// We want better testability information. `accessibilityIdentifier` and `accessibilityLabel` alone are not good for testing.
//
// List of issues with `accessibilityIdentifier` and `accessibilityLabel`:
//
// 1. Return key does not have unique identifier. For done button it is `Done`, for return button it is `Return`.
// 2. spacebar key has different `accessibilityLabel` for different locales, in English it is "space", in Russian it is "Пробел",
//    it has no `accessibilityIdentifier` or any other property useful for making a locator for page object.
//
// `UIAccessibilityElementKBKey` contains name of button that can uqiquely identify those buttons, examples:
// 1. `Return-Key`
// 2. `Space-Key`
//

import Foundation
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
import MixboxInAppServicesObjc
#endif

@objc(UIKBTreeTestablity)
final class UIKBTreeTestablity: NSObject {
    private let key: KeyboardTree
    
    @objc init(underlyingObject: UIKBTree) {
        self.key = KeyboardTree(
            underlyingPrivateApiObject: underlyingObject,
            underlyingPublicApiObject: underlyingObject
        )
    }
    
    @objc override func mb_testability_children() -> [TestabilityElement] {
        []
    }
    
    @objc override func mb_testability_parent() -> TestabilityElement? {
        handleErrorInTestabilityElementMethod(
            body: {
                try keyboardLayout.underlyingObject
            },
            defaultValue: {
                super.mb_testability_parent()
            }
        )
    }
    
    @objc override func mb_testability_frameRelativeToScreen() -> CGRect {
        handleErrorInTestabilityElementMethod(
            body: {
                var frame = try key.shape.frame
                frame.origin += try keyboardLayout.underlyingObject.mb_frameRelativeToScreen.origin.mb_asVector()
                return frame
            },
            defaultValue: {
                super.mb_testability_frameRelativeToScreen()
            }
        )

    }

    @objc override func mb_testability_elementType() -> TestabilityElementType {
        .key
    }

    @objc override func mb_testability_getSerializedCustomValues() -> [String: String] {
        let testabilityCustomValues = TestabilityCustomValues(mb_testability_customValues)

        // This is useful to uniquely identify a key in UI tests
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.name"] = handleErrorInTestabilityElementMethod(
            body: {
                try key.name
            },
            defaultValue: {
                nil
            }
        )

        // Include also other interesting properties
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.displayString"] = key.displayString
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.representedString"] = key.representedString
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.localizationKey"] = key.localizationKey
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.displayRowHint"] = key.displayRowHint

        return testabilityCustomValues.serializedDictionary
    }
    
    private var keyboardLayout: KeyboardLayout {
        get throws {
            try KeyboardPrivateApi.sharedInstance().layout().unwrapOrThrow()
        }
    }
}

#endif
