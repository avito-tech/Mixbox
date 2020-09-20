#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIAccessibilityElement {
    @objc override open func mb_testability_frame() -> CGRect {
        if #available(iOS 10.0, *) {
            return accessibilityFrameInContainerSpace
        } else {
            // TODO (non-view elements): Try to calculate based on `accessibilityFrame` and parents?
            return .null
        }
    }
}

#endif
