#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
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
public final class KeyboardKeyViewHierarchyElement: TestabilityElementViewHierarchyElement {
    private let testabilityElement: NSObject
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let keyboardLayoutFrame: CGRect
    
    public init(
        testabilityElement: NSObject,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        keyboardLayoutFrame: CGRect
    ) {
        self.testabilityElement = testabilityElement
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.keyboardLayoutFrame = keyboardLayoutFrame
        
        super.init(
            testabilityElement: testabilityElement,
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
        )
    }
    
    override public var frame: CGRect {
        var frame = testabilityElement.accessibilityFrame
        frame.origin -= keyboardLayoutFrame.origin.mb_asVector()
        return floatValuesForSr5346Patcher.patched(frame: frame)
    }
    
    override public var customValues: [String : String] {
        guard let uiAccessibilityElementKBKeyClass = NSClassFromString("UIAccessibilityElementKBKey") else {
            return super.customValues
        }
        
        guard testabilityElement.isKind(of: uiAccessibilityElementKBKeyClass) else {
            return super.customValues
        }
        
        guard let key = testabilityElement.value(forKey: "key") as? NSObject else {
            return super.customValues
        }
    
        guard let name = key.value(forKey: "name") as? String else {
            return super.customValues
        }
        
        let testabilityCustomValues = TestabilityCustomValues()
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.name"] = name
        
        return super.customValues.merging(testabilityCustomValues.dictionary) { lhs, _ in
            lhs
        }
    }
}

#endif
