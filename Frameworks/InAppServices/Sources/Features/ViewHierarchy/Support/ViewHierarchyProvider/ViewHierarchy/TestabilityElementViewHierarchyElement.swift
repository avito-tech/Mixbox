#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxTestability
import MixboxFoundation
import MixboxIpcCommon

open class TestabilityElementViewHierarchyElement: ViewHierarchyElement {
    private let testabilityElement: TestabilityElement
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    private let accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    private let swiftUIViewHierarchyElementExtractor: SwiftUIViewHierarchyElementExtractor

    public init(
        testabilityElement: TestabilityElement,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher,
        accessibilityUniqueObjectMap: AccessibilityUniqueObjectMap
    ) {
        // TODO: Remove side-effects from init
        accessibilityUniqueObjectMap.register(element: testabilityElement)
        
        self.testabilityElement = testabilityElement
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
        self.accessibilityUniqueObjectMap = accessibilityUniqueObjectMap

        self.swiftUIViewHierarchyElementExtractor = SwiftUIViewHierarchyElementExtractor(
            floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
            accessibilityUniqueObjectMap: accessibilityUniqueObjectMap
        )
    }
    
    public var frame: CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frame()
        )
    }
    
    public var frameRelativeToScreen: CGRect {
        floatValuesForSr5346Patcher.patched(
            frame: testabilityElement.mb_testability_frameRelativeToScreen()
        )
    }
    
    public var customClass: String {
        testabilityElement.mb_testability_customClass()
    }
    
    public var elementType: ViewHierarchyElementType {
        TestabilityElementTypeConverter.covertToViewHierarchyElementType(
            elementType: testabilityElement.mb_testability_elementType()
        )
    }
    
    public var accessibilityIdentifier: String? {
        testabilityElement.mb_testability_accessibilityIdentifier()
    }
    
    public var accessibilityLabel: String? {
        // TODO: Avoid using swizzled implementation and return originalAccessibilityLabel directly from view.
        EnhancedAccessibilityLabel.originalAccessibilityLabel(
            accessibilityLabel: testabilityElement.mb_testability_accessibilityLabel()
        )
    }
    
    public var accessibilityValue: String? {
        testabilityElement.mb_testability_accessibilityValue()
    }
    
    public var accessibilityPlaceholderValue: String? {
        // TODO: Avoid using EnhancedAccessibilityLabel
        EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
            accessibilityPlaceholderValue: testabilityElement.mb_testability_accessibilityPlaceholderValue()
        )
    }
    
    public var text: String? {
        testabilityElement.mb_testability_text()
    }
    
    public var uniqueIdentifier: String {
        testabilityElement.mb_testability_uniqueIdentifier()
    }
    
    public var isDefinitelyHidden: Bool {
        testabilityElement.mb_testability_isDefinitelyHidden()
    }
    
    public var isEnabled: Bool {
        testabilityElement.mb_testability_isEnabled()
    }
    
    public var hasKeyboardFocus: Bool {
        testabilityElement.mb_testability_hasKeyboardFocus()
    }
    
    public var customValues: [String: String] {
        testabilityElement.mb_testability_getSerializedCustomValues()
    }
    
    public var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(
            testabilityElement.mb_testability_children().lazy.map { [floatValuesForSr5346Patcher, accessibilityUniqueObjectMap, swiftUIViewHierarchyElementExtractor] testabilityElement in
                if let view = testabilityElement as? UIView, let element = swiftUIViewHierarchyElementExtractor.extractViewHierarchyElement(from: view) {
                    return element
                } else {
                    return TestabilityElementViewHierarchyElement(
                        testabilityElement: testabilityElement,
                        floatValuesForSr5346Patcher: floatValuesForSr5346Patcher,
                        accessibilityUniqueObjectMap: accessibilityUniqueObjectMap
                    )
                }
            }
        )
    }
}

#endif
