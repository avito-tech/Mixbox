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
