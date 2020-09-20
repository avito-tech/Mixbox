#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIView {
    @objc override open func mb_testability_frameRelativeToScreen() -> CGRect {
        return convert(bounds, to: nil)
    }
}

#endif
