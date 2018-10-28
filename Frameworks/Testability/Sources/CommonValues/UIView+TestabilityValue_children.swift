#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIView {
    @objc override open func testabilityValue_children() -> [UIView] {
        return subviews
    }
}

#endif
