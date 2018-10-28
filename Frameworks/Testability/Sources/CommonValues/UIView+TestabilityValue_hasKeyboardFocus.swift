#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UITextField {
    override open func testabilityValue_hasKeyboardFocus() -> Bool {
        return isFirstResponder
    }
}

extension UITextView {
    override open func testabilityValue_hasKeyboardFocus() -> Bool {
        return isFirstResponder
    }
}

#endif
