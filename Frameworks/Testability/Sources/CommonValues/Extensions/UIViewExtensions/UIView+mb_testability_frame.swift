#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UIView {
    @objc override open func mb_testability_frame() -> CGRect {
        return frame
    }
}

#endif
