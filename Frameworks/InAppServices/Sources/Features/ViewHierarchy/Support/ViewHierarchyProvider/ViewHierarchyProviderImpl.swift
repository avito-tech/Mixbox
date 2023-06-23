#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxTestability
import MixboxUiKit
import UIKit

// TODO: Remove AccessibilityUniqueObjectMap singleton
public final class ViewHierarchyProviderImpl: ViewHierarchyProvider {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let keyboardPrivateApi: KeyboardPrivateApi
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        keyboardPrivateApi: KeyboardPrivateApi
    ) {
        self.applicationWindowsProvider = applicationWindowsProvider
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.keyboardPrivateApi = keyboardPrivateApi
    }
    
    public func viewHierarchy() -> ViewHierarchy {
        return ViewHierarchy(rootElements: buildViewHierarchyElements())
    }
    
    // MARK: - Private
    private func buildViewHierarchyElements() -> [ViewHierarchyElement] {
        return applicationWindowsProvider.windows.map(buildViewHierarchyElement) + keyboardViewHierarchyElements()
    }
    
    private func buildViewHierarchyElement(testabilityElement: TestabilityElement) -> ViewHierarchyElement {
        AccessibilityUniqueObjectMap.shared.register(element: testabilityElement)
        
        return ViewHierarchyElement(
            frame: frame(testabilityElement),
            frameRelativeToScreen: frameRelativeToScreen(testabilityElement),
            customClass: customClass(testabilityElement),
            elementType: elementType(testabilityElement),
            accessibilityIdentifier: accessibilityIdentifier(testabilityElement),
            accessibilityLabel: accessibilityLabel(testabilityElement),
            accessibilityValue: accessibilityValue(testabilityElement),
            accessibilityPlaceholderValue: accessibilityPlaceholderValue(testabilityElement),
            text: text(testabilityElement),
            uniqueIdentifier: uniqueIdentifier(testabilityElement),
            isDefinitelyHidden: isDefinitelyHidden(testabilityElement),
            isEnabled: isEnabled(testabilityElement),
            hasKeyboardFocus: hasKeyboardFocus(testabilityElement),
            customValues: customValues(testabilityElement),
            children: children(testabilityElement)
        )
    }
    
    private func keyboardViewHierarchyElements() -> [ViewHierarchyElement] {
        guard let keyboardLayout = keyboardPrivateApi.layout() else {
            return []
        }
        
        AccessibilityUniqueObjectMap.shared.register(element: keyboardLayout)
        
        return [
            ViewHierarchyElement(
                frame: frame(keyboardLayout),
                frameRelativeToScreen: frameRelativeToScreen(keyboardLayout),
                customClass: customClass(keyboardLayout),
                elementType: .keyboard,
                accessibilityIdentifier: accessibilityIdentifier(keyboardLayout),
                accessibilityLabel: accessibilityLabel(keyboardLayout),
                accessibilityValue: accessibilityLabel(keyboardLayout),
                accessibilityPlaceholderValue: accessibilityPlaceholderValue(keyboardLayout),
                text: text(keyboardLayout),
                uniqueIdentifier: uniqueIdentifier(keyboardLayout),
                isDefinitelyHidden: isDefinitelyHidden(keyboardLayout),
                isEnabled: isEnabled(keyboardLayout),
                hasKeyboardFocus: hasKeyboardFocus(keyboardLayout),
                customValues: [:],
                children: (0..<keyboardLayout.accessibilityElementCount()).compactMap { index in
                    keyboardLayout.accessibilityElement(at: index).map { accessibilityElement in
                        keyboardKeyViewHierarchyElement(
                            // Note: `keyboardLayout` doesn't represent full keyboard. It misses the UI of predictive input on top of the UI represented by keyboardLayout
                            keyboardLayoutFrame: keyboardLayout.accessibilityFrame,
                            accessibilityElement: accessibilityElement
                        )
                    }
                }
            )
        ]
    }
    
    private func keyboardKeyViewHierarchyElement(
        keyboardLayoutFrame: CGRect,
        accessibilityElement: Any
    ) -> ViewHierarchyElement {
        if let testabilityElement = accessibilityElement as? NSObject {
            return keyboardKeyViewHierarchyElement(
                keyboardLayoutFrame: keyboardLayoutFrame,
                testabilityElement: testabilityElement
            )
        } else {
            return unknownKeyViewHierarchyElement(accessibilityElement: accessibilityElement)
        }
    }
    
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
    private func keyboardKeyViewHierarchyElement(
        keyboardLayoutFrame: CGRect,
        testabilityElement: NSObject
    ) -> ViewHierarchyElement {
        guard let uiAccessibilityElementKBKeyClass = NSClassFromString("UIAccessibilityElementKBKey") else {
            return buildViewHierarchyElement(
                testabilityElement: testabilityElement
            )
        }
        
        guard testabilityElement.isKind(of: uiAccessibilityElementKBKeyClass) else {
            return buildViewHierarchyElement(
                testabilityElement: testabilityElement
            )
        }
        
        guard let key = testabilityElement.value(forKey: "key") as? NSObject else {
            return buildViewHierarchyElement(
                testabilityElement: testabilityElement
            )
        }
    
        guard let name = key.value(forKey: "name") as? String else {
            return buildViewHierarchyElement(
                testabilityElement: testabilityElement
            )
        }
        
        let testabilityCustomValues = TestabilityCustomValues()
        testabilityCustomValues["MixboxBuiltinCustomValue.UIKBKey.name"] = name
        
        AccessibilityUniqueObjectMap.shared.register(element: testabilityElement)
        
        var frame = testabilityElement.accessibilityFrame
        frame.origin -= keyboardLayoutFrame.origin.mb_asVector()
        
        return ViewHierarchyElement(
            frame: floatValuesForSr5346Patcher.patched(frame: frame),
            frameRelativeToScreen: frameRelativeToScreen(testabilityElement),
            customClass: customClass(testabilityElement),
            elementType: elementType(testabilityElement),
            accessibilityIdentifier: accessibilityIdentifier(testabilityElement),
            accessibilityLabel: accessibilityLabel(testabilityElement),
            accessibilityValue: accessibilityValue(testabilityElement),
            accessibilityPlaceholderValue: accessibilityPlaceholderValue(testabilityElement),
            text: text(testabilityElement),
            uniqueIdentifier: uniqueIdentifier(testabilityElement),
            isDefinitelyHidden: isDefinitelyHidden(testabilityElement),
            isEnabled: isEnabled(testabilityElement),
            hasKeyboardFocus: hasKeyboardFocus(testabilityElement),
            customValues: customValues(testabilityElement).merging(testabilityCustomValues.dictionary) { lhs, _ in
                lhs
            },
            children: children(testabilityElement)
        )
    }
    
    // In case we don't know how to process element, this can be used.
    // The idea is that we don't miss the fact that we can't process element, because it will be visible in logs.
    private func unknownKeyViewHierarchyElement(accessibilityElement: Any) -> ViewHierarchyElement {
        return ViewHierarchyElement(
            frame: .zero,
            frameRelativeToScreen: .zero,
            customClass: "\(type(of: accessibilityElement))",
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
            children: []
        )
    }
    
    private func frame(_ testabilityElement: TestabilityElement) -> CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frame()
        )
    }
    private func frameRelativeToScreen(_ testabilityElement: TestabilityElement) -> CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frameRelativeToScreen()
        )
    }
    private func customClass(_ testabilityElement: TestabilityElement) -> String {
        testabilityElement.mb_testability_customClass()
    }
    private func elementType(_ testabilityElement: TestabilityElement) -> ViewHierarchyElementType {
        TestabilityElementTypeConverter.covertToViewHierarchyElementType(
            elementType: testabilityElement.mb_testability_elementType()
        )
    }
    private func accessibilityIdentifier(_ testabilityElement: TestabilityElement) -> String? {
        testabilityElement.mb_testability_accessibilityIdentifier()
    }
    private func accessibilityLabel(_ testabilityElement: TestabilityElement) -> String? {
        // TODO: Avoid using swizzled implementation and return originalAccessibilityLabel directly from view.
        EnhancedAccessibilityLabel.originalAccessibilityLabel(
            accessibilityLabel: testabilityElement.mb_testability_accessibilityLabel()
        )
    }
    private func accessibilityValue(_ testabilityElement: TestabilityElement) -> String? {
        testabilityElement.mb_testability_accessibilityValue()
    }
    private func accessibilityPlaceholderValue(_ testabilityElement: TestabilityElement) -> String? {
        EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
            accessibilityPlaceholderValue: testabilityElement.mb_testability_accessibilityPlaceholderValue()
        )
    }
    private func text(_ testabilityElement: TestabilityElement) -> String? {
        testabilityElement.mb_testability_text()
    }
    private func uniqueIdentifier(_ testabilityElement: TestabilityElement) -> String {
        testabilityElement.mb_testability_uniqueIdentifier()
    }
    private func isDefinitelyHidden(_ testabilityElement: TestabilityElement) -> Bool {
        testabilityElement.mb_testability_isDefinitelyHidden()
    }
    private func isEnabled(_ testabilityElement: TestabilityElement) -> Bool {
        testabilityElement.mb_testability_isEnabled()
    }
    private func hasKeyboardFocus(_ testabilityElement: TestabilityElement) -> Bool {
        testabilityElement.mb_testability_hasKeyboardFocus()
    }
    private func customValues(_ testabilityElement: TestabilityElement) -> [String: String] {
        testabilityElement.mb_testability_customValues.dictionary
    }
    private func children(_ testabilityElement: TestabilityElement) -> [ViewHierarchyElement] {
        testabilityElement.mb_testability_children().map(buildViewHierarchyElement)
    }
}

#endif
