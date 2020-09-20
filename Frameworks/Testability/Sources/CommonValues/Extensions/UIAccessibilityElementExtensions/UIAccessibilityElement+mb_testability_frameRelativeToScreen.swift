#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIAccessibilityElement {
    @objc override open func mb_testability_frameRelativeToScreen() -> CGRect {
        return accessibilityFrame
    }
}

#endif
