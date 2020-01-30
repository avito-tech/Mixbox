#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
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
    
    private func buildRootViewHierarchyElement(from view: UIView) -> ViewHierarchyElement {
        AccessibilityUniqueObjectMap.shared.register(object: view)
        
        return ViewHierarchyElement(
            frame: floatValuesForSr5346Patcher.patched(
                frame: view.frame
            ),
            frameRelativeToScreen: floatValuesForSr5346Patcher.patched(
                frame: view.convert(view.bounds, to: nil)
            ),
            customClass: String(describing: type(of: view)),
            elementType: TestabilityElementTypeConverter.covertToViewHierarchyElementType(
                elementType: view.testabilityValue_elementType()
            ),
            accessibilityIdentifier: view.accessibilityIdentifier,
            // TODO: Avoid using swizzled implementation and return originalAccessibilityLabel directly from view.
            accessibilityLabel: EnhancedAccessibilityLabel.originalAccessibilityLabel(
                accessibilityLabel: view.accessibilityLabel
            ),
            accessibilityValue: view.accessibilityValue,
            accessibilityPlaceholderValue: EnhancedAccessibilityLabel.originalAccessibilityPlaceholderValue(
                accessibilityPlaceholderValue: view.accessibilityPlaceholderValue() as? String
            ),
            text: view.testabilityValue_text(),
            uniqueIdentifier: view.uniqueIdentifier,
            isDefinitelyHidden: view.isDefinitelyHidden,
            isEnabled: view.testabilityValue_isEnabled(),
            hasKeyboardFocus: view.testabilityValue_hasKeyboardFocus(),
            customValues: view.testability_customValues.dictionary,
            children: view.testabilityValue_children().map(buildRootViewHierarchyElement)
        )
    }
}

#endif
