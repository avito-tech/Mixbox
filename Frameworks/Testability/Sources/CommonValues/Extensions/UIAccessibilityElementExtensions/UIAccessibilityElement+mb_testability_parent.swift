#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIAccessibilityElement {
    @objc override open func mb_testability_parent() -> TestabilityElement? {
        return accessibilityContainer.map {
            TestabilityElementFromAnyConverter.testabilityElement(
                anyElement: $0
            )
        }
    }
}

#endif
