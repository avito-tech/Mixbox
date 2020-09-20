#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UITextField {
    @objc override open func mb_testability_hasKeyboardFocus() -> Bool {
        return isFirstResponder
    }
}

extension UITextView {
    @objc override open func mb_testability_hasKeyboardFocus() -> Bool {
        return isFirstResponder
    }
}

#endif
