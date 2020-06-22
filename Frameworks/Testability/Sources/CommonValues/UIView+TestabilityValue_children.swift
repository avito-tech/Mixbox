#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxTestability_objc
extension UIView {
    @objc override open func testabilityValue_children() -> [UIView] {
        return subviews
    }
}

#endif
