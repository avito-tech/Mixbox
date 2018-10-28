#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

extension UILabel {
    override open func testabilityValue_visibleText() -> String? {
        return text ?? ""
    }
}

extension UITextView {
    override open func testabilityValue_visibleText() -> String? {
        return text ?? ""
    }
}

extension UITextField {
    override open func testabilityValue_visibleText() -> String? {
        if let text = text, !text.isEmpty {
            return text
        } else {
            return placeholder
        }
    }
}

extension UIButton {
    override open func testabilityValue_visibleText() -> String? {
        guard let label = titleLabel else {
            return ""
        }
        
        if label.isHidden == true || label.alpha == 0 {
            return ""
        }
        
        return label.testabilityValue_visibleText()
    }
}

#endif
