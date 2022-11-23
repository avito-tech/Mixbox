#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpcCommon
import MixboxTestability
import UIKit

// TODO: Remove AccessibilityUniqueObjectMap singleton
public final class ViewHierarchyProviderImpl: ViewHierarchyProvider {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    private let floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider,
        floatValuesForSr5346Patcher: FloatValuesForSr5346Patcher)
    {
        self.applicationWindowsProvider = applicationWindowsProvider
        self.floatValuesForSr5346Patcher = floatValuesForSr5346Patcher
    }
    
    public func viewHierarchy() -> ViewHierarchy {
        return ViewHierarchy(rootElements: buildRootViewHierarchyElements())
    }
    
    // MARK: - Private
    private func buildRootViewHierarchyElements() -> [ViewHierarchyElement] {
        return applicationWindowsProvider.windows.map(buildRootViewHierarchyElement)
    }
    
    private func buildRootViewHierarchyElement(from element: TestabilityElement) -> ViewHierarchyElement {
        AccessibilityUniqueObjectMap.shared.register(element: element)
        
        return ViewHierarchyElement(
            frame: floatValuesForSr5346Patcher.patched(
                frame: element.mb_testability_frame()
            ),
            frameRelativeToScreen: floatValuesForSr5346Patcher.patched(
                frame: element.mb_testability_frameRelativeToScreen()
            ),
            customClass: element.mb_testability_customClass(),
            elementType: TestabilityElementTypeConverter.covertToViewHierarchyElementType(
                elementType: element.mb_testability_elementType()
            ),
            accessibilityIdentifier: element.mb_testability_accessibilityIdentifier(),
            // TODO: Avoid using swizzled implementation and return originalAccessibilityLabel directly from view.
            accessibilityLabel: EnhancedAccessibilityLabel.originalAccessibilityLabel(
                accessibilityLabel: element.mb_testability_accessibilityLabel()
            ),
            accessibilityValue: element.mb_testability_accessibilityValue(),
            accessibilityPlaceholderValue: EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
                accessibilityPlaceholderValue: element.mb_testability_accessibilityPlaceholderValue()
            ),
            text: element.mb_testability_text(),
            uniqueIdentifier: element.mb_testability_uniqueIdentifier(),
            isDefinitelyHidden: element.mb_testability_isDefinitelyHidden(),
            isEnabled: element.mb_testability_isEnabled(),
            hasKeyboardFocus: element.mb_testability_hasKeyboardFocus(),
            customValues: element.mb_testability_customValues.dictionary,
            children: element.mb_testability_children().map(buildRootViewHierarchyElement)
        )
    }
}

#endif
