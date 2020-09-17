#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIView {
    @objc override open func mb_testability_isEnabled() -> Bool {
        return isUserInteractionEnabled
    }
}

extension UIControl {
    @objc override open func mb_testability_isEnabled() -> Bool {
        return isEnabled
    }
}

#endif
