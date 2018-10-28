#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import UIKit

final class ViewHierarchyBuilder {
    func buildViewHierarchy() -> ViewHierarchy {
        return ViewHierarchy(rootElements: buildRootViewHierarchyElements())
    }
    
    // MARK: - Private
    private func buildRootViewHierarchyElements() -> [ViewHierarchyElement] {
        return UIApplication.shared.windows.map(buildRootViewHierarchyElement)
    }
    
    private func buildRootViewHierarchyElement(from view: UIView) -> ViewHierarchyElement {
        AccessibilityUniqueObjectMap.shared.register(object: view)
        
        return ViewHierarchyElement(
            frame: view.frame,
            customClass: String(describing: type(of: view)),
            elementType: TestabilityElementTypeConverter.covertToViewHierarchyElementType(
                elementType: view.testabilityValue_elementType()
            ),
            accessibilityIdentifier: view.accessibilityIdentifier,
            accessibilityLabel: view.accessibilityLabel,
            accessibilityValue: view.accessibilityValue,
            accessibilityPlaceholderValue: view.accessibilityPlaceholderValue() as? String,
            visibleText: view.testabilityValue_visibleText(),
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
