#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

public final class KeyboardLayoutViewHierarchyElement: TestabilityElementViewHierarchyElement {
    private let keyboardLayout: UIView
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    
    public init(
        keyboardLayout: UIView,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    ) {
        self.keyboardLayout = keyboardLayout
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        
        super.init(
            testabilityElement: keyboardLayout,
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
        )
    }
    
    override public var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            (0..<keyboardLayout.accessibilityElementCount()).lazy.map { [keyboardLayout, floatValuesForSr5346Patcher] index in
                keyboardLayout.accessibilityElement(at: index).map { accessibilityElement in
                    Self.keyboardKeyViewHierarchyElement(
                        // Note: `keyboardLayout` doesn't represent full keyboard. It misses the UI of predictive input on top of the UI represented by keyboardLayout
                        keyboardLayoutFrame: keyboardLayout.accessibilityFrame,
                        accessibilityElement: accessibilityElement,
                        floatValuesForSr5346Patcher: floatValuesForSr5346Patcher
                    )
                } ?? Self.unknownKeyViewHierarchyElement(
                    customClass: "ERROR: `accessibilityElement` at index \(index) is nil"
                )
            }
        )
    }
    
    override public var elementType: ViewHierarchyElementType {
        .keyboard
    }
    
    // MARK: - Private
    
    private static func keyboardKeyViewHierarchyElement(
        keyboardLayoutFrame: CGRect,
        accessibilityElement: Any,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    ) -> ViewHierarchyElement {
        if let testabilityElement = accessibilityElement as? NSObject {
            return KeyboardKeyViewHierarchyElement(
                testabilityElement: testabilityElement,
                floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
                keyboardLayoutFrame: keyboardLayoutFrame
            )
        } else {
            return unknownKeyViewHierarchyElement(accessibilityElement: accessibilityElement)
        }
    }
    
    // In case we don't know how to process element, this can be used.
    // The idea is that we don't miss the fact that we can't process element, because it will be visible in logs.
    private static func unknownKeyViewHierarchyElement(accessibilityElement: Any) -> ViewHierarchyElement {
        return unknownKeyViewHierarchyElement(
            customClass: "\(type(of: accessibilityElement))"
        )
    }
    
    private static func unknownKeyViewHierarchyElement(customClass: String) -> ViewHierarchyElement {
        return CodableViewHierarchyElement(
            frame: .zero,
            frameRelativeToScreen: .zero,
            customClass: customClass,
            elementType: .other,
            accessibilityIdentifier: nil,
            accessibilityLabel: "Unknown element, unsupported by Mixbox, please, support it or file a request",
            accessibilityValue: nil,
            accessibilityPlaceholderValue: nil,
            text: nil,
            uniqueIdentifier: UUID().uuidString,
            isDefinitelyHidden: false,
            isEnabled: false,
            hasKeyboardFocus: false,
            customValues: [:],
            codableChildren: []
        )
    }
}

#endif
