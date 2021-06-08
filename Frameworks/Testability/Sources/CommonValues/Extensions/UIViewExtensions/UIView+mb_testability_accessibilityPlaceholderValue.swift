#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UITextField {
    @objc override open func mb_testability_accessibilityPlaceholderValue() -> String? {
        return placeholder
    }
}

#endif
