#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxTestability_objc

extension UIView {
    override open func testabilityValue_isEnabled() -> Bool {
        return isUserInteractionEnabled
    }
}

extension UIControl {
    override open func testabilityValue_isEnabled() -> Bool {
        return isEnabled
    }
}

#endif
